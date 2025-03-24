# **Importing data from dataset folder to pgadmin**

## **2 ways**
1. **Using PGadmin:**
    - `go to pgadmin`
    - `double the database`
    - `double the schemas`
    - `double click on tables`
    - `right click on the table name which you want to insert data`
    - `click on Import/Export data`
    - `select import/export as import`
    - `enter correct path to the dataset file location`
    - `format as csv`
    - `click on ok`
    - `right click on table refresh the table`
    - `now run this command in sql querry tool` `SELECT * FROM table name`

2. **Using Sql querry:**
    - `have to give permission to pgadmin to locate and load the file from path - by default the permission will be denied.`
    - `go to file explorer and select the where the dataset lies`
    - `right click on it`
    - `click on properties`
    - `go security`
    - `click on add`
    - `now check the `SERVICE_START_NAME` in cmd by entering this command  in cmd`
        ```cmd 
        sc qc postgresql-x64-version_number
        ex:
            sc qc postgresql-x64-17
        ```
    - `now copy the `SERVICE_START_NAME` name add it on security under `object names``
    - `if it gives error`
    - `instead of SERVICE_START_NAME write "Everyone" and click on `ok` and gives access to `read and execute` under permission section.`
    - `click on ok and ok. done`
    - `now go to pgadmin open sql querry tool and  run type this`
    ```cmd
        COPY bronze.crm_cust_info FROM 'C:/Users/anoop/datawarehousing/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' --replace this with original path
        WITH CSV HEADER DELIMITER ',';
    ```

