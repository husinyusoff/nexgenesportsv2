# 🐳 NexGen Esportsv2 - Docker Development Manual

This guide explains how to develop, run, and test your java application using the new Docker-based infrastructure.

---

## 1. Quick Start (Running Everything)
To start the entire development stack (Database, phpMyAdmin, and Tomcat):
1. Ensure **Docker Desktop** is running.
2. Open your terminal in the project root (`d:\nexgenesportsv2-1`).
3. Run:
   ```powershell
   docker-compose up -d
   ```
4. Access your app at: **http://localhost:8080/NexGenEsportsv2**

---

## 2. Development Workflow (How to Code)
Since your project folder is "mounted" into Docker, any changes you make locally can be seen by the container.

### Step-by-Step for Code Changes:
1.  **Edit**: Change your `.java`, `.jsp`, or `.css` files in VS Code and save.
2.  **Package**: Rebuild the project using Maven:
   ```powershell
   & "d:\nexgenesportsv2-1\.tools\apache-maven-3.9.6\bin\mvn.cmd" package
   ```
3.  **Live Update**: Tomcat inside Docker will see the updated `.war` file in your `target/` folder and **automatically reload it**.
    *   *Note: This might take 5-10 seconds to complete.*

---

## 3. Database Management (CRUD)
The database is running inside Docker, but you can interact with it just like before.

### Using phpMyAdmin:
1. Go to: **http://localhost:8081**
2. **Username**: `root`
3. **Password**: (blank)
4. Select the `trial_nexgenesports` database on the left sidebar.

### Inside your Java Code:
The database connection host is now `db` instead of `localhost`. 
*   **JDBC URL**: `jdbc:mysql://db:3306/trial_nexgenesports`
*   **User**: `root` / **Password**: (blank)

---

## 4. Testing & Troubleshooting

### Check Container Status:
To see if your containers are healthy:
```powershell
docker-compose ps
```

### View Live Logs:
If your app isn't loading or you want to see standard output (e.g., `System.out.println`):
```powershell
docker logs -f nexgenesports_web
```

### Stopping the Stack:
When you're finished for the day:
```powershell
docker-compose down
```
*(Your database data is persistent and will be saved in the `mysql_data` volume).*

---

## 5. Summary of Ports:
| Service | URL | Port |
| :--- | :--- | :--- |
| **Main App** | `http://localhost:8080/NexGenEsportsv2` | 8080 |
| **phpMyAdmin** | `http://localhost:8081` | 8081 |
| **MySQL (internal)**| `db:3306` | 3306 |
