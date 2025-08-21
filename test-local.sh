#!/bin/bash

# Interwave Under Construction - Local Test Server
# Quick script to test the page locally

set -e

# Configuration
PORT=${1:-8080}
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX_FILE="$PROJECT_DIR/index.html"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if index.html exists
if [[ ! -f "$INDEX_FILE" ]]; then
    echo "Error: index.html not found in $PROJECT_DIR"
    exit 1
fi

print_info "Interwave Under Construction - Local Test Server"
print_info "Project directory: $PROJECT_DIR"
print_info "Starting server on port $PORT..."

# Check if port is available
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
    print_warning "Port $PORT is already in use. Trying next available port..."
    PORT=$((PORT + 1))
fi

# Start local server
print_info "Opening browser..."

# Try different methods to start a local server
if command -v python3 &> /dev/null; then
    print_success "Starting Python 3 HTTP server on port $PORT"
    echo ""
    echo "🌐 Local URL: http://localhost:$PORT"
    echo "📂 Serving: $PROJECT_DIR"
    echo ""
    echo "Press Ctrl+C to stop the server"
    echo ""
    
    # Open browser (works on macOS, Linux, and Windows)
    if command -v open &> /dev/null; then
        open "http://localhost:$PORT"  # macOS
    elif command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:$PORT"  # Linux
    elif command -v start &> /dev/null; then
        start "http://localhost:$PORT"  # Windows
    fi
    
    cd "$PROJECT_DIR"
    python3 -m http.server $PORT
    
elif command -v python &> /dev/null; then
    print_success "Starting Python 2 HTTP server on port $PORT"
    echo ""
    echo "🌐 Local URL: http://localhost:$PORT"
    echo "📂 Serving: $PROJECT_DIR"
    echo ""
    echo "Press Ctrl+C to stop the server"
    echo ""
    
    if command -v open &> /dev/null; then
        open "http://localhost:$PORT"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:$PORT"
    elif command -v start &> /dev/null; then
        start "http://localhost:$PORT"
    fi
    
    cd "$PROJECT_DIR"
    python -m SimpleHTTPServer $PORT
    
elif command -v php &> /dev/null; then
    print_success "Starting PHP built-in server on port $PORT"
    echo ""
    echo "🌐 Local URL: http://localhost:$PORT"
    echo "📂 Serving: $PROJECT_DIR"
    echo ""
    echo "Press Ctrl+C to stop the server"
    echo ""
    
    if command -v open &> /dev/null; then
        open "http://localhost:$PORT"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:$PORT"
    elif command -v start &> /dev/null; then
        start "http://localhost:$PORT"
    fi
    
    cd "$PROJECT_DIR"
    php -S localhost:$PORT
    
elif command -v node &> /dev/null && command -v npx &> /dev/null; then
    print_success "Starting Node.js HTTP server on port $PORT"
    echo ""
    echo "🌐 Local URL: http://localhost:$PORT"
    echo "📂 Serving: $PROJECT_DIR"
    echo ""
    echo "Press Ctrl+C to stop the server"
    echo ""
    
    if command -v open &> /dev/null; then
        open "http://localhost:$PORT"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:$PORT"
    elif command -v start &> /dev/null; then
        start "http://localhost:$PORT"
    fi
    
    cd "$PROJECT_DIR"
    npx http-server -p $PORT
    
else
    print_warning "No suitable web server found!"
    echo ""
    echo "To test the page, you can:"
    echo "1. Install Python: python3 -m http.server $PORT"
    echo "2. Install PHP: php -S localhost:$PORT"
    echo "3. Install Node.js: npx http-server -p $PORT"
    echo "4. Open index.html directly in your browser"
    echo ""
    echo "Direct file path: file://$INDEX_FILE"
    
    # Try to open the file directly
    if command -v open &> /dev/null; then
        print_info "Opening file directly in default browser..."
        open "$INDEX_FILE"
    elif command -v xdg-open &> /dev/null; then
        print_info "Opening file directly in default browser..."
        xdg-open "$INDEX_FILE"
    elif command -v start &> /dev/null; then
        print_info "Opening file directly in default browser..."
        start "$INDEX_FILE"
    fi
fi