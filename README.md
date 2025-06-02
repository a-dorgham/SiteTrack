![MATLAB](https://img.shields.io/badge/MATLAB-R2021b-blue.svg)
![SQLite](https://img.shields.io/badge/Database-SQLite-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

# SiteTrack O&M Management System

SiteTrack is a comprehensive MATLAB-based application designed to manage operations and maintenance (O&M) activities. It includes dedicated modules for warehouse inventory, road maintenance, and electrical infrastructure management. With an intuitive interface, SiteTrack simplifies work order tracking, materials management, and report generation.

---

## 🔧 Key Features

- 🏗️ **Modular System**: Manage roads, buildings, and electrical networks in one platform  
- 📦 **Warehouse Management**: Track inventory of materials and equipment  
- 🛣️ **Road Maintenance**: Log detailed work orders and maintenance activities  
- ⚡ **Electrical Maintenance**: Monitor lighting, networks, and panel maintenance  
- 📊 **Data Visualization**: Plot inventory trends and maintenance activity  
- 📅 **Historical Filtering**: Review records by day, week, or month  
- 📄 **Report Generation**: Export data to Word and Excel  
- 🔒 **User Authentication**: Secure login for multi-user access  
- 🖼️ **Image Support**: Attach before/after images for maintenance records  

---

## 📁 Project Structure

```
SiteTrack/
├── SiteTrack.m                # Main application launcher
├── assets/
│   ├── data/                  # Configs and templates
│   │   ├── headingsRoads.txt
│   │   ├── maintenanceType.txt
│   │   ├── roadsTables.mat
│   │   └── warehouse.xlsx
│   ├── databases/             # SQLite database files
│   ├── icons/                 # UI icons
│   ├── pictures/              # Work documentation photos
│   └── templates/             # Report templates
└── utilities/
    ├── createDB.m             # Script to initialize database
    └── SplashScreen.m         # App splash screen component
```

---

## 🚀 Getting Started

### 🔩 Prerequisites

- MATLAB **R2021b or later**
- SQLite database generated with `createDB.m`

### ⚙️ Setup Instructions

1. **Configure Data Files**  
   - Customize field names and types in `assets/data/`  
   - Update `warehouse.xlsx` and `warehouseElec.xlsx` with your materials inventory
     
2. **Create Database**  
   - Run `createDB.m` from the `utilities/` folder  
   - Move the generated `dbOandM.db` to `assets/databases/`

3. **Launch Application**  
   - Open MATLAB  
   - Run `SiteTrack.m`

---

## 📚 Usage Overview

### 🔐 Login Screen  
- Enter employee ID and password  
- Access levels vary by user type  
<img width="412" alt="login" src="https://github.com/user-attachments/assets/39609c21-684c-4ebb-b5bd-86ed14306ba6" />


### 🏠 Main Menu  
- Navigate to Roads, Buildings, or Electrical modules  
- Access warehouse and reporting functions
![categories](https://github.com/user-attachments/assets/3ab5e31a-3032-495d-b309-0fa6f91ec2a6)

  

### 📝 Work Orders  
1. Choose module (e.g., Roads or Electrical)  
2. Input:
   - Work description  
   - Location  
   - Materials and equipment used  
   - Attach images (before/after)
![log](https://github.com/user-attachments/assets/5223ea82-b0ca-4630-9454-455a484eeacb)



### 📦 Warehouse Management  
- View/edit inventory  
- Filter by category  
- Track material usage  
- Generate reports

<img width="612" alt="warehouse" src="https://github.com/user-attachments/assets/219f5f3e-61e2-4f5a-bdc7-df68fea5f227" />


### 🔍 Data Review  
- Filter by date (daily/weekly/monthly)  
- Search entries  
- Export filtered data to reports
  
<img width="612" alt="month_log" src="https://github.com/user-attachments/assets/6b2477c3-b010-4cf7-9bae-9d95037266f1" />


### 📊 Reports  
- Generate reports in **Word** and **Excel**  
- Create summaries or inventory status reports  

<img width="613" alt="report_menu" src="https://github.com/user-attachments/assets/336b9d82-f8db-4d8f-8925-6c86dc94fc46" />

<img width="612" alt="report" src="https://github.com/user-attachments/assets/11a7d562-ff00-421b-8381-e9f7ff2c1a5c" />

---

## 🛠 Module Details

### 🏗️ Roads Maintenance
- Log concrete, asphalt, and interlock works  
- Track infrastructure repairs, fencing, painting  

### ⚡ Electrical Maintenance
- Record lighting and panel maintenance  
- Log line hazards, lantern installs, and materials  

### 📦 Warehouse System
- Track multiple material categories  
- Monitor stock levels and historical usage  
- Set low-stock alerts  

---

## ⚠️ Known Limitations

- **Database Setup**: `createDB.m` must be run initially  
- **Image Support**: Only PNG and JPG formats  
- **Word Reporting**: Requires MS Word for full functionality  
- **Concurrency**: Built for **single-user** use  

---

## 🛠 Developer Notes

### Database
- Uses **SQLite** with schema defined in `createDB.m`  
- Extensible for future features  

### Customization
- Update `assets/data/` text files for labels and types  
- Modify `roadsTables.mat`, `elecTables.mat` for structure  
- Add icons to `assets/icons/`  

### Extensibility
- Add new modules by expanding `SiteTrack.m`  
- Include additional templates in `assets/templates/`  

---

## 📜 License

This project is licensed under the **MIT License**.

---

## 📬 Contact

For questions, support, or feature requests:  
📧 Email: [a.k.y.dorgham@gmail.com](mailto:a.k.y.dorgham@gmail.com)  
🔗 Connect: [LinkedIn](#) | [Google Scholar](#)

---

## 🙏 Acknowledgements

- **MATLAB** – for the application framework  
- **SQLite** – for lightweight database support  
