#!/bin/bash

# Create a directory for log files if it doesn't exist
LOG_DIR="network_logs"
mkdir -p "$LOG_DIR"

# Initialize log files with headers
echo "Timestamp,Status" > "$LOG_DIR/gateway_outages.csv"
echo "Timestamp,Status" > "$LOG_DIR/google_outages.csv"
echo "Timestamp,Status" > "$LOG_DIR/routing_outages.csv"

# Function to log ping results
log_ping() {
    local target=$1
    local logfile=$2
    local display_name=$3
    
    if ping -c 1 -W 2 "$target" > /dev/null; then
        echo -e "\e[32m✓ $display_name is reachable\e[0m"
        return 0
    else
        echo -e "\e[31m✗ $display_name is unreachable\e[0m"
        echo "$(date '+%Y-%m-%d %H:%M:%S'),UNREACHABLE" >> "$logfile"
        return 1
    fi
}

# Main monitoring loop
echo "Starting network monitoring..."
echo "Press Ctrl+C to stop monitoring"
echo "Logs will be saved in the $LOG_DIR directory"
echo "----------------------------------------"

while true; do
    echo -e "\n$(date '+%Y-%m-%d %H:%M:%S')"
    
    # Monitor gateway
    log_ping "192.168.10.1" "$LOG_DIR/gateway_outages.csv" "Gateway (192.168.10.1)"
    
    # Monitor Google
    log_ping "google.com" "$LOG_DIR/google_outages.csv" "Google (google.com)"
    
    # Monitor routing
    log_ping "8.8.8.8" "$LOG_DIR/routing_outages.csv" "routing (8.8.8.8)"
    
    # Wait 5 seconds before next check
    sleep 5
done
