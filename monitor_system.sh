#!/bin/bash

# Define thresholds (adjust these according to your requirements)
CPU_THRESHOLD=80   # in percent
MEM_THRESHOLD=80   # in percent
DISK_THRESHOLD=80  # in percent

# Function to check CPU usage
check_cpu() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        echo "High CPU usage detected: ${cpu_usage}%"
        # You can add additional actions here (e.g., sending an alert)
    fi
}

# Function to check memory usage
check_memory() {
    local mem_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
    if (( $(echo "$mem_usage > $MEM_THRESHOLD" | bc -l) )); then
        echo "High memory usage detected: ${mem_usage}%"
        # You can add additional actions here (e.g., sending an alert)
    fi
}

# Function to check disk space
check_disk() {
    local disk_usage=$(df -h / | awk '/\//{print $(NF-1)}' | sed 's/%//')
    if (( disk_usage > DISK_THRESHOLD )); then
        echo "High disk usage detected: ${disk_usage}%"
        # You can add additional actions here (e.g., sending an alert)
    fi
}

# Function to check running processes
check_processes() {
    local process_count=$(ps aux | wc -l)
    local process_threshold=500  # Adjust as needed
    if (( process_count > process_threshold )); then
        echo "High number of running processes detected: ${process_count}"
        # You can add additional actions here (e.g., sending an alert)
    fi
}

# Main function to run checks
main() {
    check_cpu
    check_memory
    check_disk
    check_processes
}

# Execute main function
main
