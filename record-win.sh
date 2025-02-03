#!/bin/bash

# Initialize default values for optional parameters
verbose=false
output=""
file=""

# Function to display usage/help
usage() {
  echo "Usage: $0 [options] <required_param>"
  echo "Options:"
  echo "  -h, --help          Show help message and exit"
  echo "  -v, --verbose       Enable verbose output"
  echo "  -f, --file <file>   Specify the input file (required)"
  echo "  -o, --output <file> Specify the output file (optional)"
}

# Parse short flags with getopts
while getopts "hvf:o:" opt; do
  case $opt in
    h) # Display help
      usage
      exit 0
      ;;
    v) # Verbose flag
      verbose=true
      ;;
    f) # Input file (required)
      file=$OPTARG
      ;;
    o) # Output file (optional)
      output=$OPTARG
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

# Parse long flags manually if needed
shift $((OPTIND-1))  # Shift past options processed by getopts

# Handle long flags manually (if getopts doesn't cover them)
for arg in "$@"; do
  case $arg in
    --help)
      usage
      exit 0
      ;;
    --verbose)
      verbose=true
      ;;
    --file)
      shift
      file=$1
      ;;
    --output)
      shift
      output=$1
      ;;
    *)
      echo "Unknown option: $arg"
      usage
      exit 1
      ;;
  esac
done

# Now that the flags have been parsed, you can use the variables
# Check for required parameters
if [ -z "$file" ]; then
  echo "Error: --file <file> is required."
  usage
  exit 1
fi

# Main script logic
echo "Running script with parameters:"
echo "File: $file"
echo "Verbose: $verbose"
echo "Output: $output"
