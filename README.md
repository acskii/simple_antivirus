# Antivirus Program

## Table of Contents

- [Overview](#overview)
- [Running](#running)
  - [Antivirus](#running-the-antivirus-tool)
  - [Restore](#running-the-restore-tool)
- [Malicious File Definition](#malicious-file-definition)
- [Plan](#plan)

## Overview

A simple antivirus system implemented entirely in Bash.

It [watches](#antivirusdsh) a directory for [suspicious](#malicious-file-definition) files, quarantines anything that looks malicious, and provides an interactive [tool](#restoresh) to review, restore, or permanently delete quarantined files.

## Running

### Running the antivirus tool

There are **two** ways to execute the antivirus program: [single process](#single-process) or [cron job](#cron-job)

#### Single Process

This can be run using the [Makefile](./Makefile) provided in the project.

For a full list of all targets, run `make help` in the terminal.

To run the antivirus program, only run this command:

```bash
make
```

This runs the default `all` target in the Makefile that executes `prebuild` and `virusd` sequentially. Check the Makefile for more details.

#### Cron Job

>[!NOTE]
>
> As part of the assignment, it is required to provide the cron expression for running the antivirus program scan every **3rd** **Friday** of the month at **12:31 am**
>
> *Answer:* `31 0 15-21 * 5`

Follow the following steps to schedule the cron job:

1. Make sure `crontab` is available in your system by running:

    ```bash
        man crontab
    ```

    Although it is usually pre-packaged in any Linux distribution.

2. Make sure that your user is not denied access to cron jobs by running these commands:

    ```bash
        cd /etc && cat cron.deny 
    ```

    If you find your username, remove it from `cron.deny`.

3. Copy the absolute path to [antivirus-cron.sh](./antivirus-cron.sh), your scan **dir** and quarantine **malicious_dir** using `pwd`.

4. Run:

    ```bash
        crontab -e
    ```

5. Paste this line into the `nano` screen that is displayed then press `Ctrl + X` and `Y`:

    ```bash
    * * * * * sleep 23 && /path/to/antivirus-cron.sh /path/to/dir /path/to/malicious/dir
    ```

6. Verify successful cron job scheduling by running:

    ```bash
        crontab -l
    ```

    You should see the **same** command that was used in previous step in this list.

To remove the cron job, use:

```bash
    crontab -r
```

### Running the restore tool

This can be run using the [Makefile](./Makefile) provided in the project.

For a full list of all targets, run `make help` in the terminal.

To run the restore program, only run this command:

```bash
make restore
```

## Malicious File Definition

### Extensions

The program checks if the file extension matches with any one of these extensions and **no other**:

- .exe
- .bat
- .vbs
- .scr
- .ps1

### Text Content

The program checks if the file content contains any one of these *exact* words:

- virus
- trojan
- malware
- worm
- ransomware

## Plan

This is a feature-based plan created solely for my own convenience as a measure to track the progress of this project.
You can view this to get an overview of how the project was planned and what features are currently being worked on.

### [antivirusd.sh](./antivirusd.sh)

#### Initial Skeleton

[x] Pass 3 arguments required and store them as variables

[x] Confirm that directories given exist

[x] Confirm that interval given is positive

[x] Perfom command `ls -l dir > directory-info.last` to preserve current state if it doesn't already exist, otherwise skip it

[x] Start interval loop once every **interval_sec**

[x] Perfom command `ls -l dir > directory-info.new` to preserve current state once every **interval_sec** of the interval loop

#### Comparison

[x] Compare the `directory-info.new` with the `directory-info.last` and check for differences

[x] Skip to next loop if no differences are detected

[x] Copy `directory-info.last` into `directory-info.new` if differences are detected

#### Malicious Detection

[x] Setup extension array and word array that records malicious keywords and extensions stated in [Malicious File Definition](#malicious-file-definition) section

[x] Complete scan function to implement following steps:

[x] Loop through all files in **dir** and only scan files

[x] Check if the file basename ends with a malicious extension

[x] Check, using `grep`, if a malicious keyword exists in the file content

[x] If either of the above two were fulfilled, start [Action on Detection](#action-on-detection) steps

#### Action on Detection

[x] Print to the terminal: `<file> is malicious and it is DELETED`

[x] Copy the file into **malicious_dir**, keeping its original filename

[x] Delete the original file from **dir**

#### Edge Case

[x] On the very first run, perform a scan immediately then create `directory-info.last` from the current state.

### [restore.sh](./restore.sh)

#### User Menu

[x] List all files in **malicious_dir**

[x] Present **three** options *after* file selection:

[x] Input 1: Restore this file back into **dir**

[x] Input 2: Permanently delete this file from **malicious_dir**

[x] Input 3: Leave this file as-is and go back to the list

#### Actions

[x] Input 1: Move file back into **dir**

[x] Input 2: Remove file

[x] Input 3: List all files in **malicious_dir** again

#### Logging

[x] Log `Restored <file> to <dir>.` after input 1

[x] Log `<file> permanently deleted.` after input 2

[x] Log `No malicious files to review.` if **malicious_dir** is empty
