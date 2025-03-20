# MongoDB Eiffel Driver

A MongoDB driver implementation for the Eiffel programming language, providing a wrapper around the MongoDB C Driver (libmongoc).

## Overview

This project provides a MongoDB driver for Eiffel, consisting of:

- **C Driver**: The C driver for MongoDB
- **BSON Library**: A wrapper for the BSON (Binary JSON) implementation
- **MongoDB Library**: The core MongoDB driver functionality
    - **Example REST API**: A demonstration of using the driver in a real application
    - **Tutorial**: A tutorial showing how to use the driver

## Project Structure

The project is organized into several main components:

- `/C`: C driver build utilities
  - Contains scripts for building the required C libraries
 
- `/bson`: BSON implementation wrapper
 
- `/mongodb`: Core MongoDB driver
  - `src`: Source code of the Eiffel code 
  - `test`: Test the driver
  - `/tutorial`: Tutorial showing how to use the driver
  - `/basic`:- Demonstrates basic CRUD operations
  - `/examples`: Sample implementations
      - REST API example showing real-world usage
  

## Prerequisites

- EiffelStudio (latest version recommended)
- C compiler (for building the MongoDB C Driver)
- MongoDB server (for running the examples)

