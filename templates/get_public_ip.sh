#!/bin/bash
echo "{\"public_ip\": \"$(curl -s ifconfig.me)\"}"
