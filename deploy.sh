#!/bin/bash

# Interwave Under Construction - Deployment Script
# Usage: ./deploy.sh [server] [path] [method]

set -e

# Configuration
PROJECT_NAME="Interwave Under Construction"
LOCAL_FILE="index.html"
BACKUP_SUFFIX=".backup-$(date +%Y%m%d-%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_help() {
    echo "Interwave Under Construction - Deployment Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --server HOST      Server hostname or IP"
    echo "  -u, --user USER        SSH username"
    echo "  -p, --path PATH        Remote path to deploy to"
    echo "  -m, --method METHOD    Deployment method (scp|rsync|local)"
    echo "  -k, --key KEYFILE      SSH private key file"
    echo "  -b, --backup           Create backup of existing files"
    echo "  -t, --test             Test mode (show commands without executing)"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -s server.com -u admin -p /var/www/html"
    echo "  $0 -m local -p /Users/yoyaku/Sites/interwave"
    echo "  $0 -s server.com -u admin -p /var/www/html -k ~/.ssh/id_rsa -b"
    echo ""
}

# Default values
METHOD="local"
BACKUP_ENABLED=false
TEST_MODE=false
SSH_KEY=""
SERVER=""
USER=""
REMOTE_PATH=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--server)
            SERVER="$2"
            shift 2
            ;;
        -u|--user)
            USER="$2"
            shift 2
            ;;
        -p|--path)
            REMOTE_PATH="$2"
            shift 2
            ;;
        -m|--method)
            METHOD="$2"
            shift 2
            ;;
        -k|--key)
            SSH_KEY="$2"
            shift 2
            ;;
        -b|--backup)
            BACKUP_ENABLED=true
            shift
            ;;
        -t|--test)
            TEST_MODE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validation
if [[ ! -f "$LOCAL_FILE" ]]; then
    print_error "Local file '$LOCAL_FILE' not found!"
    exit 1
fi

if [[ -z "$REMOTE_PATH" ]]; then
    print_error "Remote path is required!"
    show_help
    exit 1
fi

print_status "Starting deployment of $PROJECT_NAME"
print_status "Method: $METHOD"
print_status "Local file: $LOCAL_FILE"
print_status "Target path: $REMOTE_PATH"

if [[ "$TEST_MODE" == true ]]; then
    print_warning "TEST MODE ENABLED - Commands will be shown but not executed"
fi

# Execute deployment based on method
case $METHOD in
    "local")
        print_status "Local deployment mode"
        
        # Create directory if it doesn't exist
        if [[ "$TEST_MODE" == true ]]; then
            echo "mkdir -p \"$REMOTE_PATH\""
        else
            mkdir -p "$REMOTE_PATH"
        fi
        
        # Backup existing file
        if [[ "$BACKUP_ENABLED" == true && -f "$REMOTE_PATH/index.html" ]]; then
            if [[ "$TEST_MODE" == true ]]; then
                echo "cp \"$REMOTE_PATH/index.html\" \"$REMOTE_PATH/index.html$BACKUP_SUFFIX\""
            else
                cp "$REMOTE_PATH/index.html" "$REMOTE_PATH/index.html$BACKUP_SUFFIX"
                print_success "Backup created: $REMOTE_PATH/index.html$BACKUP_SUFFIX"
            fi
        fi
        
        # Copy file
        if [[ "$TEST_MODE" == true ]]; then
            echo "cp \"$LOCAL_FILE\" \"$REMOTE_PATH/index.html\""
        else
            cp "$LOCAL_FILE" "$REMOTE_PATH/index.html"
            print_success "File deployed successfully to $REMOTE_PATH/index.html"
        fi
        ;;
        
    "scp")
        if [[ -z "$SERVER" || -z "$USER" ]]; then
            print_error "Server and user are required for SCP deployment!"
            exit 1
        fi
        
        print_status "SCP deployment mode"
        print_status "Target: $USER@$SERVER:$REMOTE_PATH"
        
        # Build SSH options
        SSH_OPTS=""
        if [[ -n "$SSH_KEY" ]]; then
            SSH_OPTS="-i $SSH_KEY"
        fi
        
        # Backup existing file
        if [[ "$BACKUP_ENABLED" == true ]]; then
            BACKUP_CMD="ssh $SSH_OPTS $USER@$SERVER 'if [ -f $REMOTE_PATH/index.html ]; then cp $REMOTE_PATH/index.html $REMOTE_PATH/index.html$BACKUP_SUFFIX; fi'"
            if [[ "$TEST_MODE" == true ]]; then
                echo "$BACKUP_CMD"
            else
                eval $BACKUP_CMD
                print_success "Remote backup created"
            fi
        fi
        
        # Deploy file
        SCP_CMD="scp $SSH_OPTS \"$LOCAL_FILE\" $USER@$SERVER:$REMOTE_PATH/index.html"
        if [[ "$TEST_MODE" == true ]]; then
            echo "$SCP_CMD"
        else
            eval $SCP_CMD
            print_success "File deployed successfully via SCP"
        fi
        ;;
        
    "rsync")
        if [[ -z "$SERVER" || -z "$USER" ]]; then
            print_error "Server and user are required for rsync deployment!"
            exit 1
        fi
        
        print_status "Rsync deployment mode"
        print_status "Target: $USER@$SERVER:$REMOTE_PATH"
        
        # Build rsync options
        RSYNC_OPTS="-av --progress"
        if [[ -n "$SSH_KEY" ]]; then
            RSYNC_OPTS="$RSYNC_OPTS -e 'ssh -i $SSH_KEY'"
        fi
        
        # Backup existing file
        if [[ "$BACKUP_ENABLED" == true ]]; then
            RSYNC_OPTS="$RSYNC_OPTS --backup --suffix=$BACKUP_SUFFIX"
        fi
        
        # Deploy file
        RSYNC_CMD="rsync $RSYNC_OPTS \"$LOCAL_FILE\" $USER@$SERVER:$REMOTE_PATH/index.html"
        if [[ "$TEST_MODE" == true ]]; then
            echo "$RSYNC_CMD"
        else
            eval $RSYNC_CMD
            print_success "File deployed successfully via rsync"
        fi
        ;;
        
    *)
        print_error "Unknown deployment method: $METHOD"
        print_error "Supported methods: local, scp, rsync"
        exit 1
        ;;
esac

# Final verification
if [[ "$TEST_MODE" == false ]]; then
    print_status "Deployment completed!"
    print_status "Next steps:"
    echo "  1. Test the page in a browser"
    echo "  2. Update DNS if needed"
    echo "  3. Monitor for any issues"
    echo ""
    
    if [[ "$BACKUP_ENABLED" == true ]]; then
        print_status "Backup file created with suffix: $BACKUP_SUFFIX"
        print_status "To rollback: mv index.html$BACKUP_SUFFIX index.html"
    fi
fi