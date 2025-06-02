clc
createDB_Electricity = true;

% =========================================================================
% Create Maintenace warehouse table ---------------------------------------

delete('dbOandM.db')
dbName = 'dbOandM.db';
dbFile = fullfile(pwd, dbName);
dbConnection = sqlite(dbFile, 'create');

columnType = {'NUMERIC', 'VARCHAR', 'DATE', 'DOUBLE', 'INTEGER', 'FLOAT'};
columnDefault = {0, 'character', '2020-01-01'};

warehouseColumns = {'Category', 'Code', 'Item', 'Unit', 'Quantity', 'Notes'};
cType = columnType([2 5 2 2 4 2]);
Column_Type_Cell = append(warehouseColumns, ' ', cType);
Column_Type = sprintf('%s, ', string(Column_Type_Cell));
createTable = ['create table ', 'warehouseTable', ' (', Column_Type(1:end-2), ')'];
exec(dbConnection, createTable)

data = readtable(fullfile('assets', 'data', 'warehouse.xlsx'));
dataCell = table2cell(data);
insert(dbConnection, 'warehouseTable', warehouseColumns, dataCell)

cellCat = dataCell(:,6);
cellCode = dataCell(:,5);
cellItem = dataCell(:,4);

roadsTables = [];
roadsTablesAr = [];
tableFields = {'roads_description','roads_machines','roads_tools','roads_roadMat','roads_infraMat', ...
    'roads_fenceMat','roads_signalMat','roads_PaintMat','roads_others'};

categories = {'Equipment', 'Tools', 'Road Materials', 'Infrastructure Materials', ...
    'Fencing Materials', 'Sign Materials', 'Paint Materials', 'Seedlings'};

for i = 1:numel(tableFields)
    if i == 1
        roadsTables.(tableFields{i}) = ["ID", "Supervisor", "Day", "Date", "Authority", "Type", "Neighborhood", "Street_Name", "Street_Number", ...
            "Leveling_Area", "Damaged_Length", "Damaged_Width", "Damaged_Area", "PictureBefore", "PictureAfter", "Description"];
        roadsTablesAr.(tableFields{i}) = ["Number", "Engineer", "Day", "Date", "Area", "Type", "District Name", "Street Name", "Street Number", ...
            "Gravel Area - m²", "Maintenance Area Length - m", "Maintenance Area Width - m", "Maintenance Area - m²", "Before Image", "After Image", "Work Description"];
    elseif any(i == [2, 3, 4])
        idx = ismember(cellCat, categories{i-1});
        roadsTables.(tableFields{i}) = ["ID", string(cellCode(idx))'];
        roadsTablesAr.(tableFields{i}) = ["Number", string(cellItem(idx))'];
    else
        idx = ismember(cellCat, categories{i-1});
        roadsTables.(tableFields{i}) = ["ID", "Description", string(cellCode(idx))'];
        roadsTablesAr.(tableFields{i}) = ["Number", "Description", string(cellItem(idx))'];
    end
end

tablePath = fullfile('assets', 'data', 'roadsTables.mat');
save(tablePath, 'roadsTables')
tablePath = fullfile('assets', 'data', 'roadsTablesAr.mat');
save(tablePath, 'roadsTablesAr')

roadsTablesFields = fields(roadsTables);
roadsTablesCells = struct2cell(roadsTables);
for i = 1:numel(roadsTablesFields)
    n = numel(roadsTablesCells{i});
    if i == 1
        cType = columnType([1 2 2 3 2 2 2 2 4 4 4 4 4 2 2 2]);
        cDefault = columnDefault([1 2 2 3 2 2 2 2 1 1 1 1 1 2 2 2]);
    elseif any(i == [2, 3, 4])
        cType1 = columnType(1);
        cDefault1 = columnDefault(1);
        cType2 = repmat(columnType(4), 1, n-1);
        cDefault2 = repmat(columnDefault(1), 1, n-1);
        cType = [cType1, cType2];
        cDefault = [cDefault1, cDefault2];
    else
        cType1 = columnType(1);
        cDefault1 = columnDefault(1);
        cType2 = columnType(2);
        cDefault2 = columnDefault(2);
        cType3 = repmat(columnType(4), 1, n-2);
        cDefault3 = repmat(columnDefault(1), 1, n-2);
        cType = [cType1, cType2, cType3];
        cDefault = [cDefault1, cDefault2, cDefault3];
    end

    Column_Type_Cell = append('"', roadsTablesCells{i}, '" ', cType);
    Column_Type = sprintf('%s, ', string(Column_Type_Cell));
    createTable = ['create table ' roadsTablesFields{i}, ' (', Column_Type(1:end-2), ')'];
    exec(dbConnection, createTable)
    insert(dbConnection, roadsTablesFields{i}, append('"', roadsTables.(roadsTablesFields{i}), '"'), cDefault)
end

    disp('Maintenace warehouse table was created successfully.')


% =========================================================================
% Create Electricity warehouse table --------------------------------------

if createDB_Electricity == true

    dbName = 'dbOandM.db';
    dbFile = fullfile(pwd, dbName);
    dbConnection = sqlite(dbFile, 'connect');

    columnType = {'NUMERIC', 'VARCHAR', 'DATE', 'DOUBLE', 'INTEGER', 'FLOAT'};
    columnDefault = {0, 'NA', '2020-01-01'};

    warehouseColumns = {'Category', 'Code', 'Item', 'Unit', 'Quantity', 'Notes'};
    cType = columnType([2 5 2 2 4 2]);
    Column_Type_Cell = append(warehouseColumns, ' ', cType);
    Column_Type = sprintf('%s, ', string(Column_Type_Cell));
    exec(dbConnection, 'DROP TABLE IF EXISTS warehouseElecTable');
    createTable = ['create table ', 'warehouseElecTable', ' (', Column_Type(1:end-2), ')'];
    exec(dbConnection, createTable)

    data = readtable(fullfile('assets', 'data', 'warehouseElec.xlsx'));
    dataCell = table2cell(data);
    insert(dbConnection, 'warehouseElecTable', warehouseColumns, dataCell)

    cellCat = dataCell(:,6);
    cellCode = dataCell(:,5);
    cellItem = dataCell(:,4);

    elecTables = [];
    elecTablesAr = [];
    tableFields = {'elec_description', 'elec_cashaf', 'elec_fanos', 'elec_machines', 'elec_mat', 'elec_panel', 'elec_cables', ...
        'elec_danger', 'elec_others'};

    categories = {'Flashlight', 'Lantern', 'Equipment', 'Materials', 'Panel', 'Lines', 'Danger', 'Other'};

    for i = 1:numel(tableFields)
        if i == 1
            elecTables.(tableFields{i}) = ["ID", "Supervisor", "Day", "Date", "Authority", "Type", "Neighborhood", "Street_Name", "Street_Number", ...
                "Team", "Outward", "Inward", "Hours", "PictureBefore", "PictureAfter", "Description"];
            elecTablesAr.(tableFields{i}) = ["Number", "Engineer", "Day", "Date", "Agency", "Type", "District Name", "Street Name", "Street Number", ...
                "Technical Team", "Departure Time", "Return Time", "Working Hours", "Before Photo", "After Photo", "Description of Work"];
        else
            idx = ismember(cellCat, categories{i-1});
            elecTables.(tableFields{i}) = ["ID", "Description", string(cellCode(idx))'];
            elecTablesAr.(tableFields{i}) = ["Number", "Description of Work", string(cellItem(idx))'];
        end
    end

    tablePath = fullfile('assets', 'data', 'elecTables.mat');
    save(tablePath, 'elecTables')
    tablePath = fullfile('assets', 'data', 'elecTablesAr.mat');
    save(tablePath, 'elecTablesAr')

    elecTablesFields = fields(elecTables);
    elecTablesCells = struct2cell(elecTables);
    for i = 1:numel(elecTablesFields)
        n = numel(elecTablesCells{i});
        if i == 1
            cType = columnType([1 2 2 3 2 2 2 2 4 2 4 4 4 2 2 2]);
            cDefault = columnDefault([1 2 2 3 2 2 2 2 1 2 1 1 1 2 2 2]);
        else
            cType1 = columnType(1);
            cDefault1 = columnDefault(1);
            cType2 = repmat(columnType(4), 1, n-1);
            cDefault2 = repmat(columnDefault(1), 1, n-1);
            cType = [cType1, cType2];
            cDefault = [cDefault1, cDefault2];
        end

        Column_Type_Cell = append('"', elecTablesCells{i}, '" ', cType);
        Column_Type = sprintf('%s, ', string(Column_Type_Cell));
        exec(dbConnection, ['DROP TABLE IF EXISTS ' elecTablesFields{i}]);
        createTable = ['create table ' elecTablesFields{i}, ' (', Column_Type(1:end-2), ')'];
        exec(dbConnection, createTable)
        insert(dbConnection, elecTablesFields{i}, append('"', elecTables.(elecTablesFields{i}), '"'), cDefault)
    end

    close(dbConnection);

    disp('Electricity warehouse table was created successfully.')
end
