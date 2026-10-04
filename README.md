# Antivirus Program

## Table of Contents

- [Overview](#overview)
- [Setup](#setup)
- [Running](#running)
- [Malicious File Definition](#malicious-file-definition)
- [Plan](#plan)

## Overview

## Setup

```bash
chmod +x antivirusd.sh
```

## Running

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

### antivirusd.sh

#### Initial Skeleton

[x] Pass 3 arguments required and store them as variables

[x] Confirm that directories given exist

[x] Confirm that interval given is positive

[x] Perfom command `ls -l dir > directory-info.last` to preserve current state if it doesn't already exist, otherwise skip it

[x] Start interval loop once every **interval_sec**

[x] Perfom command `ls -l dir > directory-info.new` to preserve current state once every **interval_sec** of the interval loop

#### Comparison

