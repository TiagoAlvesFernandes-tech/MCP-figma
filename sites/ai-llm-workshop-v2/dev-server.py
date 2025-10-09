#!/usr/bin/env python3
# Servidor de desenvolvimento local
import http.server
import socketserver
import os
import webbrowser
from pathlib import Path

PORT = 3000
directory = Path(__file__).parent

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=directory, **kwargs)

os.chdir(directory)
print(f"🌐 Servidor local iniciado: http://localhost:{PORT}")
print(f"📁 Servindo: {directory}")
print("🔄 Ctrl+C para parar")

try:
    webbrowser.open(f"http://localhost:{PORT}")
except:
    pass

with socketserver.TCPServer(("", PORT), CustomHandler) as httpd:
    httpd.serve_forever()
