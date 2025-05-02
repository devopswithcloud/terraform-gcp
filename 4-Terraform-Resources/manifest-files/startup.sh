#!/bin/bash
sudo apt update -y
sudo apt install vim -y
sudo apt install -y telnet
sudo apt install -y nginx
sudo systemctl enable nginx
sudo chmod -R 755 /var/www/html
HOSTNAME=$(hostname)
sudo echo "<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>i27 GCP Terraform Advanced Course</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f4f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #2c3e50;
        }
        .course-title {
            font-size: 48px;
            color: #2d3436;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 10px;
            background-color: #dfe6e9;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            margin-bottom: 30px;
        }
        .description {
            font-size: 24px;
            text-align: center;
            max-width: 800px;
            margin-bottom: 20px;
            color: #ffffff;
            background-color: #636e72;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
        }
        .server-info {
            font-size: 20px;
            background-color: #b2bec3;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            color: #2d3436;
        }
        .server-info p {
            margin: 10px 0;
        }
        .server-hostname {
            font-size: 22px;
            font-weight: bold;
            color: #ffffff;
            background-color: #6c5ce7; /* Light purple */
            padding: 10px;
            border-radius: 5px;
        }
        .server-ip {
            font-size: 22px;
            font-weight: bold;
            color: #ffffff;
            background-color: #00cec9; /* Light teal */
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="course-title">
        i27 GCP Terraform Advanced Course
    </div>
    <div class="description">
        Now we are seeing the example of a VM created from Terraform.
    </div>
    <div class="server-info">
        <p class="server-hostname"><strong>Server Hostname:</strong> ${HOSTNAME}</p>
        <p class="server-ip"><strong>Server IP Address:</strong> $(hostname -I)</p>
    </div>
</body>
</html>" | sudo tee /var/www/html/index.html
