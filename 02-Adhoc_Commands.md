### AdHoc commands
---

### 1. **Ping all hosts to check connectivity**
   ```bash
   ansible all -m ping
   ```
   This command checks the connectivity with all hosts defined in the inventory.

### 2. **Check uptime of remote systems**
   ```bash
   ansible all -m command -a "uptime"
   ```

### 3. **Gather facts about a remote system**
   ```bash
   ansible all -m setup
   ```

### 4. **Check disk usage**
   ```bash
   ansible all -m command -a "df -h"
   ```

### 5. **List all files in a directory**
   ```bash
   ansible all -m command -a "ls -l /path/to/directory"
   ```

### 6. **Check available memory**
   ```bash
   ansible all -m command -a "free -m"
   ```

### 7. **Restart a service (e.g., httpd)**
   ```bash
   ansible all -m service -a "name=httpd state=restarted"
   ```

### 8. **Install a package (e.g., httpd)**
   ```bash
   ansible all -m yum -a "name=httpd state=present"
   ```
   For systems using `apt`:
   ```bash
   ansible all -m apt -a "name=apache2 state=present"
   ```

### 9. **Start a service (e.g., nginx)**
   ```bash
   ansible all -m service -a "name=nginx state=started"
   ```

### 10. **Stop a service**
   ```bash
   ansible all -m service -a "name=httpd state=stopped"
   ```

### 11. **Create a file**
   ```bash
   ansible all -m file -a "path=/tmp/testfile state=touch"
   ```

### 12. **Create a directory**
   ```bash
   ansible all -m file -a "path=/tmp/testdir state=directory"
   ```

### 13. **Change file permissions**
   ```bash
   ansible all -m file -a "path=/tmp/testfile mode=0644"
   ```

### 14. **Copy a file to remote hosts**
   ```bash
   ansible all -m copy -a "src=/path/to/localfile dest=/path/to/remotefile"
   ```

### 15. **Remove a file**
   ```bash
   ansible all -m file -a "path=/tmp/testfile state=absent"
   ```

### 16. **Add a user**
   ```bash
   ansible all -m user -a "name=john state=present"
   ```

### 17. **Delete a user**
   ```bash
   ansible all -m user -a "name=john state=absent"
   ```

### 18. **Check open ports**
   ```bash
   ansible all -m command -a "netstat -tuln"
   ```

### 19. **Reboot the servers**
   ```bash
   ansible all -m reboot
   ```

### 20. **Run a shell command**
   ```bash
   ansible all -m shell -a "your-shell-command"
   ```

### 21. **Check CPU usage**
   ```bash
   ansible all -m command -a "top -bn1 | grep load"
   ```

### 22. **Fetch file from remote host**
   ```bash
   ansible all -m fetch -a "src=/path/to/remote/file dest=/path/to/local/dir"
   ```

