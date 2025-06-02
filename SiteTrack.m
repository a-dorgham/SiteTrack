function SiteTrack
format bank
clc, clear all, close all force, warning('off','all')
global win0 winMain winSub winReview winReport winLogR winLogE winWH winPlot
global windowIcon appName screenWidth screenHeight
global dbConnection dbNetworkFile dbNetworkFolder dbFilesStruct dbFiles
global lastLogNumber dateToday startDate endDate category categoryAr categoryReport categoryTable review_table
global WH_dataTable WH_selectedCells WH_table WH_savedData WH_editedData WH_displayedDate WH_type
global WH_dataChanged WHR_categories WHE_categories WH_searchRows WH_omitRows WH_searchActive
global RD_tablePath RD_tablePathAr RD_tableStuct RD_tableStuctAr RD_dataTable RD_selectedCells
global RD_table RD_savedData RD_editedData RD_displayedDate RD_type RD_editedCells
global RD_dataChanged RD_categories EC_categories RD_searchRows RD_omitRows RD_searchActive
global EC_tableStuct EC_tablePath EC_tableStuctAr EC_tablePathAr
global EC_dataTable
global image imagesNames dataTable CurrentPath oldLogValues
global userID errorCounter daysOfWeek isLogEdited reviewType
global headingsRoads headingsBuildings headingsElectricity headingsWarehouse
global emptyRoadsTable emptyBuildingsTable emptyElectricityTable
global headingsWorksSummary emptyWorksSymmary headingsMaterialsSummary emptyMaterialsSymmary
global worksSummaryTable materialsSummaryTable winPlotMove
global spsc
loadDefaults()
spsc = SplashScreen( 'Splashscreen',...
    fullfile(CurrentPath,'assets','icons','splash.png'), ...
    'ProgressBar', 'on', ...
    'ProgressPosition', 10, ...
    'ProgressRatio', 0.0 );
spsc.addText( 12, 279, 'Loading...', 'FontSize', 10, 'Color', 'white' )
drawnow
inc = 1/10.1;
dbExist = check_DB();
if dbExist
    window_login();
    drawnow
    spsc.addText( 12, 279, 'Loading login window...', 'FontSize', 10, 'Color', 'white' )
    spsc.ProgressRatio = spsc.ProgressRatio + inc;
    loadImages();
    spsc.ProgressRatio = spsc.ProgressRatio + inc;
    spsc.addText( 12, 279, 'Loading images and icons...', 'FontSize', 10, 'Color', 'white' )
    loadHeads();
    spsc.ProgressRatio = spsc.ProgressRatio + inc;
    spsc.addText( 12, 279, 'Loading data files...', 'FontSize', 10, 'Color', 'white' )
    loadWindows()
    drawnow
end
delete(spsc)
set(win0, 'Visible', 'on') % Comment this line to disable login screen
% set(winMain, 'Visible', 'on') % uncomment this line to show main window



    function loadDefaults()
        whoAmI = mfilename('fullpath');
        [CurrentPath, ~, ~] = fileparts(whoAmI);
        dbNetworkFolder = fullfile(CurrentPath, 'assets');
        windowIcon = imread(fullfile(CurrentPath,'assets','icons','icon.jpg'));
        appName = 'SiteTrack O&M v1.0';
        dateToday = char(datetime('now','Format','uuuu-MM-dd'));
        screenSize = get(0,'screensize');
        screenWidth = screenSize(3);
        screenHeight = screenSize(4);
        errorCounter = 0;
        WH_searchActive = false;
        RD_searchActive = false;
        userID = ' ';
        daysOfWeek = { 'Sunday', 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'};
        RD_tablePath = fullfile(dbNetworkFolder,'data','roadsTables.mat');
        RD_tablePathAr = fullfile(dbNetworkFolder,'data','roadsTablesAr.mat');
        RD_tableStuct = importdata(RD_tablePath);
        RD_tableStuctAr = importdata(RD_tablePathAr);
        EC_tablePath = fullfile(dbNetworkFolder,'data','elecTables.mat');
        EC_tablePathAr = fullfile(dbNetworkFolder,'data','elecTablesAr.mat');
        EC_tableStuct = importdata(EC_tablePath);
        EC_tableStuctAr = importdata(EC_tablePathAr);
        category = 'roads';
        RD_editedCells = [];
        isLogEdited = false;
        reviewType = 'reviewToday';
        oldLogValues = [];
        winPlotMove = false;
        categoryTable = 'warehouseTable';
    end



    function loadWindows()
        window_main;
        drawnow
        spsc.addText( 12, 279, 'Loading main window...', 'FontSize', 10, 'Color', 'white' )
        spsc.ProgressRatio = spsc.ProgressRatio + inc;
        window_sub(0,0);
        drawnow
        spsc.addText( 12, 279, 'Loading sub window...', 'FontSize', 10, 'Color', 'white' )
        spsc.ProgressRatio = spsc.ProgressRatio + inc;
        window_review(0,0);
        drawnow
        spsc.addText( 12, 279, 'Loading works review window...', 'FontSize', 10, 'Color', 'white' )
        spsc.ProgressRatio = spsc.ProgressRatio + inc;
        window_report(0,0);
        drawnow
        spsc.addText( 12, 279, 'Loading reports window...', 'FontSize', 10, 'Color', 'white' )
        spsc.ProgressRatio = spsc.ProgressRatio + inc;
        window_warehouse(0,0);
        drawnow
        spsc.addText( 12, 279, 'Loading warehouse window...', 'FontSize', 10, 'Color', 'white' )
        spsc.ProgressRatio = spsc.ProgressRatio + inc;
        window_LogR(0,0);
        drawnow
        spsc.addText( 12, 279, 'Loading logR window...', 'FontSize', 10, 'Color', 'white' )
        spsc.ProgressRatio = spsc.ProgressRatio + inc;
        window_LogE(0,0);
        drawnow
        spsc.addText( 12, 279, 'Loading logE window...', 'FontSize', 10, 'Color', 'white' )
        spsc.ProgressRatio = spsc.ProgressRatio + inc;
        window_plot(0,0);
        drawnow
        categoryReport = [];
    end



    function loadImages()
        imagesNames = {'roads','buildings', 'electricity', 'exec','warehouse', 'about',...
            'log','reviewToday', 'reviewWeek', 'reviewMonth', 'reports',...
            'word', 'excel','arrowDown', 'add','omit','filter','find','edit',...
            'right', 'left','exit','selectAll','selectNone',...
            'pictureBefore','pictureAfter', 'plot','works', ...
            'OK', 'Cancel'};
        for i = 1:numel(imagesNames)
            img = imread(fullfile(CurrentPath,'assets','icons', [imagesNames{i} '.png']));
            img = double(img)/255;
            index1 = img(:,:,1) == 0;
            index2 = img(:,:,2) == 0;
            index3 = img(:,:,3) == 0;
            indexWhite = index1+index2+index3==3;
            for idx = 1 : 3
                rgb = img(:,:,idx);
                rgb(indexWhite) = NaN;
                img(:,:,idx) = rgb;
            end
            image{i} = img;
        end
    end



    function window_aboutApp(~, ~)
        width_SS = 300;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        win0 = uifigure('HandleVisibility', 'on','Visible','on', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','fig','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon);
        uibutton(win0,...
            'Text','',...
            'Position',[0.25*width_SS, 0.35*height_SS, 0.5*width_SS, 0.5*height_SS],...
            'FontSize', 18,...
            'FontColor', 'black',...
            'BackgroundColor', 'white',...
            'HorizontalAlignment', 'center',...
            'Icon', windowIcon, 'Enable','off');
        Text = '<b style="color:green;"> Site Track O&M app</b> is designed by: <br> Dr. Abdel Dorgham. <br> University of Leeds. <br> V1.0 2025©</em>.<br>';
        uilabel(win0,...
            'Text', Text,...
            'Position',[0.0*width_SS, 0.0*height_SS, 1*width_SS, 0.3*height_SS],...
            'FontSize', 12,...
            'FontColor', 'black',...
            'BackgroundColor', 'none',...
            'HorizontalAlignment', 'center', 'Interpreter','html',...
            'WordWrap','on');
    end



    function window_plot(~, ~)
        width_SS = 700;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        x0 = 0.05*width_SS;
        y0 = 0.15*height_SS;
        h = 0.6*height_SS;
        winPlot = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',winMain.Position,...
            'Tag','winPlot','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon,...
            'CloseRequestFcn', @(src,event)WH_PlotHide(src));
        pos = winMain.Position;
        ax = uiaxes(winPlot,'Position',[10, 10, pos(3)-15, pos(4)-50]);
        xlabel('Date','FontWeight','bold')
        ylabel('Quantity','FontWeight','bold')
        set(ax,'XGrid','on','YGrid','on','Color',0.98*[1,1,1])
        uilabel(winPlot,...
            'Text',' ',...
            'Position',[x0+100, y0+1.1*h+12, 0.9*width_SS-200, 0.2*height_SS-20],...
            'FontSize', 17,...
            'FontColor', 'black',...
            'FontWeight','Bold',...
            'BackgroundColor', 'none',...
            'HorizontalAlignment', 'center','Tag','Title');
        idx = strcmp(imagesNames, 'left');
        uibutton(winPlot, 'push',...
            'Position',[10, height_SS-40, 30, 30],...
            'Text', '',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'HorizontalAlignment', 'center',...
            'Tag','winSub',...
            'BackgroundColor', 0.95*[1,1,1],...
            'Icon', image{idx},...
            'ButtonPushedFcn',@(src,event)WH_PlotHide(winPlot));
    end



    function WH_PlotHide(src)
        src.Visible = 'Off';
        ax = src.Children(2);
        cla(ax)
    end



    function window_warehouse0(~, ~)
        width_SS = 300;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        win6 = uifigure('HandleVisibility', 'on','Visible','on', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','fig','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon);
        uibutton(win6,...
            'Text','',...
            'Position',[0.25*width_SS, 0.35*height_SS, 0.5*width_SS, 0.5*height_SS],...
            'FontSize', 18,...
            'FontColor', 'black',...
            'BackgroundColor', 'white',...
            'HorizontalAlignment', 'center',...
            'Icon', windowIcon, 'Enable','off');
        Text = '<b style="color:red;"> This section is still under development.</br> University of Leeds. <br> V1.0 2025©</em>.<br>';
        uilabel(win6,...
            'Text', Text,...
            'Position',[0.0*width_SS, 0.0*height_SS, 1*width_SS, 0.3*height_SS],...
            'FontSize', 12,...
            'FontColor', 'black',...
            'BackgroundColor', 'none',...
            'HorizontalAlignment', 'center', 'Interpreter','html',...
            'WordWrap','on');
    end



    function loadHeads()
        headingsRoads = table2cell(readtable(fullfile(dbNetworkFolder,'data','headingsRoads.txt'),'Delimiter','tab'));
        WHR_categories = {'Tools';'Equipment';'Road Materials';'Building Materials';'Infrastructure Materials';'Fencing Materials';'Sign Materials';'Painting Materials';'Blacksmithing Materials';'Carpentry Materials';'Electrical Materials';'Seedlings'};
        WHE_categories = {'Materials';'Equipment';'Signboard';'Flashlight';'Lantern';'Lines';'Danger';'Other'};
        RD_categories = {'General Description','Equipment','Tools','Road Works','Infrastructure Works','Fencing Works','Signal Works','Painting Works','Other Works'};
        EC_categories = {'General Description', 'Flashlight Maintenance', 'Lantern Maintenance', 'Equipment', 'Materials', 'Signboard Maintenance', 'Line Maintenance', 'Hazard Removal', 'Other Work'};
        headingsWarehouse = {'Category', 'Code', 'Item', 'Unit', 'Quantity', 'Notes'};
        headingsBuildings = {'No','Date','Authority','Description', 'Supervisor',...
            'Type', 'Location',...
            'Plumbing_Work','Plumbing_Amount',...
            'Blacksmith_Work', 'Blacksmith_Amount',...
            'Carpentry_Work', 'Carpentry_Amount',...
            'Furniture_Work', 'Furniture_Amount',...
            'Other_Work', 'Other_Amount'
            };
        emptyBuildingsTable{1} = table( 1, "", "", "", "", "", "", "", 0,"",0,"",0,"",0,"",0, 'VariableNames', headingsBuildings);
        headingsElectricity = {'No','Date','Authority','Description', 'Supervisor',...
            'Type', 'Location',...
            'Cables_Work','Cables_Amount',...
            'SpareParts_Work', 'SpareParts_Amount',...
            'Roads_Work', 'Roads_Amount',...
            'Buildings_Work', 'Buildings_Amount',...
            'Other_Work', 'Other_Amount'
            };
        emptyElectricityTable{1} = table( 1, "", "", "", "", "", "", "", 0,"",0,"",0,"",0,"",0, 'VariableNames', headingsElectricity);
        headingsWorksSummary = {'Works summary for the specified period', 'Amount'};
        col1 = ["Maintenance total areas";"Total interlock area";"Total concrete area";...
            "Total asphalt area"; "Curbstone work"];
        col0 = [0;0;0;0;0];
        emptyWorksSymmary = table(col1,col0, 'VariableNames',headingsWorksSummary);
        worksSummaryTable = emptyWorksSymmary;
        headingsMaterialsSummary = {'Materials summary for the specified period', 'Amount'};
        col2 = ["New interlock areas (m^2)";"Total cement packs (number)";...
            "Total gravel ammount (ton)"; "Total basecouse ammount (ton)";...
            "Curbstone amount (m)"; "Steel amount (ton)"; "Signals number"];
        col0 = [0;0;0;0;0;0;0];
        emptyMaterialsSymmary = table(col2,col0, 'VariableNames',headingsMaterialsSummary);
        materialsSummaryTable = emptyMaterialsSymmary;
    end



    function clearApp(fig)
        switch fig.Tag
            case 'winMain'
                message = {'To exit the program, press OK','','To return to the program, press Cancel'};
            otherwise
                message = {'To exit the program, press OK','','To return to the previous menu, press Cancel and use the Back icon'};
        end
        selection = uiconfirm(fig, message,'Confirm', 'Options',{'Cancel','OK'});
        switch selection
            case 'OK'
                delete(fig)
                close(dbConnection)
                clear dbConnection
                clear global
                close all force
            case 'Cancel'
                return
        end
    end



    function window_main
        width_SS = 700;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        winMain = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','winMain','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon,...
            'CloseRequestFcn', @(src,event)clearApp(src));
        n = 5;
        g = 10;
        x0 = 10;
        y0 = 0.2*height_SS;
        w = (width_SS - 2*x0 - (n-1)*g)/n;
        h = 0.6*height_SS;
        uilabel(winMain,...
            'Text','Select one of the following categories',...
            'Position',[x0, height_SS-60, width_SS-2*x0, 0.2*height_SS],...
            'FontSize', 22,...
            'FontName','Times New Roman',...
            'FontWeight','Bold',...
            'FontColor', 'black',...
            'BackgroundColor', 'white',...
            'HorizontalAlignment', 'center','Tag','Title');
        tagAr = {'roads', 'electricity','buildings', 'exec', 'about'};
        tagEn = {'roads', 'electricity','buildings', 'exec', 'about'};
        for i = 1:n
            idx = find(strcmp(imagesNames, tagEn{i}));
            func = @(src,event)Nav_right(imagesNames{idx}, tagAr{i});
            uibutton(winMain, 'push',...
                'Position',[x0+(i-1)*(g+w), y0, w, h],...
                'Text', '',...
                'FontSize', 10,...
                'FontColor', 'red',...
                'HorizontalAlignment', 'center',...
                'Tag',imagesNames{idx},...
                'BackgroundColor', 0.95*[1,1,1],...
                "Icon", image{idx}, ...
                'ButtonPushedFcn',func);
        end
        w = 140;
        idx = strcmp(imagesNames, 'exit');
        uibutton(winMain, 'push',...
            'Position',[width_SS/2-w/2, 15, w, 30],...
            'Text', 'Exit',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'FontWeight','Bold',...
            'HorizontalAlignment', 'center',...
            'Tag','exit',...
            'BackgroundColor', 0.95*[1,1,1],...
            "Icon", image{idx}, ...
            'ButtonPushedFcn',@(src,event)clearApp(winMain));
    end



    function Nav_right(tag, tagAr)
        category = tag;
        switch tag
            case 'roads'
                categoryTable = 'warehouseTable';
                colorTag = '#77AC30';
                WH_dataTable = WH_sqlData();
                T = WH_dataTable{1};
                WH_savedData = [T.Properties.VariableNames; table2cell(T)];
                WH_editedData = WH_savedData;
                WH_type = flip(WHR_categories);
                set(WH_table, 'Data', WH_savedData)
                checkedBoxes = findobj('Type','uicheckbox','Tag','category');
                for n = 1:numel(checkedBoxes)
                    set(checkedBoxes(n),'Text',WH_type{n})
                end
            case 'buildings'
                colorTag = '#0072BD';
            case 'electricity'
                categoryTable = 'warehouseElecTable';
                colorTag = '#A2142F';
                WH_dataTable = WH_sqlData();
                T = WH_dataTable{1};
                WH_savedData = [T.Properties.VariableNames; table2cell(T)];
                WH_editedData = WH_savedData;
                WH_type = flip(WHE_categories);
                set(WH_table, 'Data', WH_savedData)
                checkedBoxes = findobj('Type','uicheckbox','Tag','category');
                for n = 1:numel(WH_type)
                    set(checkedBoxes(n),'Text',WH_type{n})
                end
            otherwise
                colorTag = 'black';
        end
        if any(strcmp({'roads','electricity'},tag))
            category = tag;
            categoryAr = tagAr;
            obj = findobj(winSub.Children,"Tag", 'Title');
            obj.Text = strcat('<b style="color:black;">Select</b> one of the following categories: <b style="color:',colorTag, ';">', tagAr);
            set(winSub,'Position', winMain.Position)
            set(winSub, 'visible','on')
            set(winMain, 'visible', 'off')
        elseif any(strcmp(tag, {'reviewToday','reviewWeek','reviewMonth'}))
            switch tag
                case 'reviewToday'
                    startDate = dateToday;
                    endDate = dateToday;
                    title1 = 'Today''s works';
                    title = append(title1, ': ', char(dateToday));
                    reviewType = 'reviewToday';
                case 'reviewWeek'
                    endDate = dateToday;
                    startDate = char(datetime('now','Format','uuuu-MM-dd') - calweeks(1));
                    title1 = 'Week Works';
                    title = append(title1, 'From', char(startDate), 'Until', char(endDate));
                    reviewType = 'reviewWeek';
                case 'reviewMonth'
                    endDate = dateToday;
                    startDate = char(datetime('now','Format','uuuu-MM-dd') - calweeks(4));
                    title1 = 'Month Works';
                    title = append(title1, 'From', char(startDate), 'Until', char(endDate));
                    reviewType = 'reviewMonth';
            end
            if strcmp(categoryTable, 'warehouseElecTable')
                taG = 'elec_description';
                RD_dataTable = RD_sqlData('elec_description', startDate, endDate, 'table');
                WH_type = flip(EC_categories);
                checkedBoxes = findobj(winReview,'Type','uicheckbox');
                tablesNames = flip(fields(EC_tableStuct));
                for n = 1:numel(checkedBoxes)
                    set(checkedBoxes(n),'Text',WH_type{n},'Tag',tablesNames{n})
                end
            else
                taG = 'roads_description';
                RD_dataTable = RD_sqlData('roads_description', startDate, endDate, 'table');
                WH_type = flip(RD_categories);
                checkedBoxes = findobj(winReview,'Type','uicheckbox');
                tablesNames = flip(fields(RD_tableStuct));
                for n = 1:numel(checkedBoxes)
                    set(checkedBoxes(n),'Text',WH_type{n},'Tag',tablesNames{n})
                end
            end
            set(findobj(winReview, 'Type', 'uilabel'), 'Text', title)
            RD_savedData = [RD_dataTable.Properties.VariableNames; table2cell(RD_dataTable)];
            RD_editedData = RD_savedData;
            set(RD_table, 'Data', RD_savedData, 'ColumnEditable', false)
            RD_table.Selection = [1 1];
            categoryReport{1} = category;
            set(winReview,'Position', winSub.Position)
            checkedBoxes = findobj(winReview, 'Type','uicheckbox');
            set(checkedBoxes,'Value',0)
            checkedBox = findobj(winReview, 'Type','uicheckbox','Tag',taG);
            set(checkedBox,'Value',1)
            set(winReview, 'visible','on')
            set(winSub, 'visible','off')
        elseif strcmp(tag, 'reports')
            win = gcf;
            set(winReport,'Position', win.Position)
            set(winReport, 'visible','on')
            set(win, 'visible','off')
            categoryReport = [];
        elseif strcmp(tag, 'warehouse')
            win = gcf;
            set(winWH,'Position', win.Position)
            if strcmp(tag, 'roads')
            elseif strcmp(tag, 'electricity')
            end
            WH_tableStyle();
            set(winWH, 'visible','on')
            set(win, 'visible','off')
        elseif strcmp(tag, 'log')
            if strcmp(categoryTable,'warehouseElecTable')
                winLog = winLogE;
                lastLogNumber = cell2mat(fetch(dbConnection,'SELECT ID FROM elec_description order by ID desc limit 1')) + 1;
            else
                winLog = winLogR;
                lastLogNumber = cell2mat(fetch(dbConnection,'SELECT ID FROM roads_description order by ID desc limit 1')) + 1;
            end
            win = gcf;
            pos0 = win.Position;
            pos1 = winLog.Position;
            x = pos0(1)+pos0(3)/2-pos1(3)/2;
            y = pos0(2)+pos0(4)/2-pos1(4)/2;
            max_x = screenWidth - pos1(3);
            max_y = screenHeight - pos1(4);
            x = min(max(x,0), max_x);
            y = min(max(y,0), max_y);
            set(winLog,'Position', [x,y,pos1(3),pos1(4)])
            if isempty(lastLogNumber)
                lastLogNumber = 1;
            end
            set(findobj(winLog,'Tag', 'editField1'),'Value', num2str(lastLogNumber));
            set(findobj(winLog,'Tag', 'editField2'),'Value', userID);
            set(winLog, 'visible','on')
            set(win, 'visible','off')
        end
    end



    function window_sub(~, ~)
        width_SS = 700;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        winSub = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','winSub','MenuBar', 'none','Resize','off',...
            'Name', appName,'NumberTitle','off','Icon', windowIcon,...
            'CloseRequestFcn', @(src,event)clearApp(src));
        n = 5;
        g = 10;
        x0 = 10;
        y0 = 0.2*height_SS;
        w = (width_SS - 2*x0 - (n-1)*g)/n;
        h = 0.6*height_SS;
        html = '<b style="color:black;">Select</b> one of the following categories: <b style="color:#77AC30;">Roads'; uilabel(winSub,...
            'Text',html,...
            'Position',[x0, height_SS-60, width_SS-2*x0, 0.2*height_SS],...
            'FontSize', 20,...
            'FontName','Times New Roman',...
            'FontWeight','Bold',...
            'BackgroundColor', 'white',...
            'Interpreter','html',...
            'HorizontalAlignment', 'center','Tag','Title');
        idx = strcmp(imagesNames, 'left');
        uibutton(winSub, 'push',...
            'Position',[10, height_SS-40, 30, 30],...
            'Text', '',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'HorizontalAlignment', 'center',...
            'Tag','winMain',...
            'BackgroundColor', 0.95*[1,1,1],...
            'Icon', image{idx},...
            'ButtonPushedFcn',@Nav_left);
        tags = {'log','reviewToday','reviewMonth', 'warehouse','reports'};
        for i = 1:n
            func = @(src,event)Nav_right(tags{i});
            idx = strcmp(imagesNames, tags{i});
            uibutton(winSub, 'push',...
                'Position',[x0+(i-1)*(g+w), y0, w, h],...
                'Text', '',...
                'FontSize', 10,...
                'FontColor', 'red',...
                'HorizontalAlignment', 'center',...
                'Tag',tags{i},...
                'BackgroundColor', 0.95*[1,1,1],...
                "Icon", image{idx}, ...
                'ButtonPushedFcn',func);
        end
        w = 140;
        idx = strcmp(imagesNames, 'exit');
        uibutton(winSub, 'push',...
            'Position',[width_SS/2-w/2, 15, w, 30],...
            'Text', 'Exit',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'FontWeight','Bold',...
            'HorizontalAlignment', 'center',...
            'Tag','exit',...
            'BackgroundColor', 0.95*[1,1,1],...
            "Icon", image{idx}, ...
            'ButtonPushedFcn',@(src,event)clearApp(winSub));
    end



    function review(tag)
        switch tag
            case 'reviewToday'
                startDate = dateToday;
                endDate = dateToday;
            case 'reviewWeek'
                endDate = dateToday;
                startDate = char(datetime('now','Format','uuuu-MM-dd') - calweeks(1));
        end
        Nav_right('review')
    end



    function result = check_DB()
        dbNetworkFile = fullfile(dbNetworkFolder, 'databases', 'dbOandM.db');
        dbNetworkBK = fullfile(dbNetworkFolder, 'databases');
        fileExist = exist(dbNetworkFile,"file");
        if fileExist ~= 0
            dbConnection = sqlite(dbNetworkFile,'connect');
            result = true;
            lastLogNumber = cell2mat(fetch(dbConnection,'SELECT ID FROM roads_description order by ID desc limit 1')) + 1;
            if isempty(lastLogNumber)
                lastLogNumber = 1;
            end
            [~, ~, ext] = fileparts(dbNetworkFile);
            outputFullFileName = fullfile(dbNetworkBK, [char(datetime('now','Format','yyyy-MM-dd')), ext] );
            copyfile(dbNetworkFile, outputFullFileName);
            dbFilesStruct = dir(fullfile(dbNetworkBK, '*.db'));
            dbFiles = {dbFilesStruct.name};
            EC_dataTable = EC_sqlData();
        else
            win0 = uifigure;
            message = {'Error connecting to database','','The maintenance program is unable to access the network','Make sure you are connected to the work network, then try again'};
            opts = uiconfirm(win0, message,'error',...
                'Icon','error', 'Options', {'OK'});
            switch opts
                case 'OK'
                    clear global
                    close all
                    lastLogNumber = 1;
                    dbConnection = [];
                    result = false;
            end
        end
    end



    function dataTable = sqlData(category, startDate, endDate)
        if strcmp(category,'roads')
            tableName = 'roadsTable';
            fieldsNames = headingsRoads;
            dataTable = emptyRoadsTable;
            tablesNames = fields(RD_tableStuct);
            columnsNames = struct2cell(RD_tableStuct);
        elseif strcmp(category,'buildings')
            tableName = 'buildingsTable';
            fieldsNames = headingsBuildings;
            dataTable = emptyBuildingsTable;
        else
            tableName = 'electricityTable';
            fieldsNames = headingsElectricity;
            dataTable = emptyElectricityTable;
        end
        if ~isempty(dbConnection)
            dataCell = fetch(dbConnection,['SELECT * from ' tablesNames{1} ' where (Date BETWEEN ''' startDate ''' AND ''' endDate ''') order by ID desc']);
            if ~isempty(dataCell)
                dataTable{1} = cell2table(dataCell,'VariableNames',columnsNames{1});
            end
        end
    end



    function dataTable = RT_sqlData2(category, startDate, endDate)
        tableName = 'roadsTable';
        fieldsNames = headingsRoads;
        fieldsArray = [8:14, 18];
        fieldsArray1 = [8, 9, 10, 11, 13];
        fieldsArray2 = [9:14,18];
        col1 = zeros(length(fieldsArray1),1);
        col2 = zeros(length(fieldsArray2),1);
        idx1 = 0;
        idx2 = 0;
        for i = fieldsArray
            field = fieldsNames{i};
            if ~isempty(dbConnection)
                dataCell = fetch(dbConnection,['SELECT ' field ' from ' tableName ' where (Date BETWEEN ''' startDate ''' AND ''' endDate ''') ']);
                if ~isempty(dataCell)
                    requiredData = sum(cell2mat(dataCell));
                    if any(i==fieldsArray1); idx1 = idx1+1; col1(idx1) = requiredData; end
                    if any(i==fieldsArray2); idx2 = idx2+1; col2(idx2) = requiredData; end
                end
            end
        end
        table1 = emptyWorksSymmary;
        table2 = emptyMaterialsSymmary;
        table1{:,2} = col1;
        table2{:,2} = col2;
        dataTable{1} = table1;
        dataTable{2} = table2;
    end



    function dataTable = sqlData2(category, startDate, endDate)
        if strcmp(category,'roads')
            tableName = 'roadsTable';
            fieldsNames = headingsRoads;
            fieldsArray = [8:14, 18];
            fieldsArray1 = [8, 9, 10, 11, 13];
            fieldsArray2 = [9:14,18];
        elseif strcmp(category,'buildings')
            tableName = 'buildingsTable';
            fieldsNames = headingsBuildings;
            fieldsArray = [8:14, 18];
            fieldsArray1 = [8, 9, 10, 11, 13];
            fieldsArray2 = [9:14,18];
        else
            tableName = 'electricityTable';
            fieldsNames = headingsElectricity;
            fieldsArray = [8:14, 18];
            fieldsArray1 = [8, 9, 10, 11, 13];
            fieldsArray2 = [9:14,18];
        end
        col1 = zeros(length(fieldsArray1),1);
        col2 = zeros(length(fieldsArray2),1);
        idx1 = 0;
        idx2 = 0;
        for i = fieldsArray
            field = fieldsNames{i};
            if ~isempty(dbConnection)
                dataCell = fetch(dbConnection,['SELECT ' field ' from ' tableName ' where (Date BETWEEN ''' startDate ''' AND ''' endDate ''') ']);
                if ~isempty(dataCell)
                    requiredData = sum(cell2mat(dataCell));
                    if any(i==fieldsArray1); idx1 = idx1+1; col1(idx1) = requiredData; end
                    if any(i==fieldsArray2); idx2 = idx2+1; col2(idx2) = requiredData; end
                end
            end
        end
        table1 = emptyWorksSymmary;
        table2 = emptyMaterialsSymmary;
        table1{:,2} = col1;
        table2{:,2} = col2;
        dataTable{1} = table1;
        dataTable{2} = table2;
    end



    function window_review0(~, ~)
        width_SS = 700;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        winReview = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','winReview','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon,...
            'CloseRequestFcn', @(src,event)clearApp(src));
        x0 = 0.05*width_SS;
        y0 = 0.15*height_SS;
        h = 0.6*height_SS;
        uilabel(winReview,...
            'Text','The logged work orders are tabulated below:',...
            'Position',[x0, y0+1.1*h, 0.9*width_SS, 0.2*height_SS],...
            'FontSize', 16,...
            'FontColor', 'black',...
            'BackgroundColor', 'white',...
            'HorizontalAlignment', 'center','Tag','Title');
        dataTable = sqlData(category, startDate, endDate);
        documentType = {'doc', 'xls'};



        functionType = {@RT_saveWordReport,@RT_saveExcelReport};
        tags = {'word','excel'};
        for i = 1:2
            idx = strcmp(imagesNames, tags{i});
            uibutton(winReview, 'push',...
                'Position',[width_SS-(3-i)*35, height_SS-40, 30, 30],...
                'Text', '',...
                'FontSize', 14,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',documentType{i},...
                'BackgroundColor', 0.95*[1,1,1],...
                'Icon', image{idx},...
                'ButtonPushedFcn',functionType{i});
        end
        idx = strcmp(imagesNames, 'left');
        uibutton(winReview, 'push',...
            'Position',[10, height_SS-40, 30, 30],...
            'Text', '',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'HorizontalAlignment', 'center',...
            'Tag','winSub',...
            'BackgroundColor', 0.95*[1,1,1],...
            'Icon', image{idx},...
            'ButtonPushedFcn',@Nav_left);
        review_table = uitable(winReview,'Data',dataTable{1},...
            'Position',[10, 0.2*y0, 0.975*width_SS, 0.8*height_SS]);
    end



    function Nav_left(hObject, ~)
        tag = hObject.Tag;
        fig = gcf;
        if strcmp(fig.Tag,'winReport')
            obj = findobj(winReport,'Type','uistatebutton');
            for i = 1:numel(obj)
                obj(i).Value = 0;
            end
        end
        if strcmp(fig.Tag,'winLogR') || strcmp(fig.Tag,'winLogE')
            pos1 = winSub.Position;
            pos0 = fig.Position;
            x = pos0(1)+pos0(3)/2-pos1(3)/2;
            y = pos0(2)+pos0(4)/2-pos1(4)/2;
            max_x = screenWidth - pos1(3);
            max_y = screenHeight - pos1(4);
            x = min(max(x,0), max_x);
            y = min(max(y,0), max_y);
            set(eval(tag),'Position', [x,y,pos1(3),pos1(4)])
            tg = findobj(fig,'Type', 'uitabgroup');
            tg.SelectedTab = tg.Children(1);
            if strcmp(categoryTable, 'warehouseElecTable')
                EC_clearLog;
            else
                RD_clearLog;
            end
        else
            set(eval(tag),'Position', fig.Position)
        end
        if strcmp(fig.Tag,'winWH')
            okCancel = findobj(fig, 'Type','uibutton','Tag', 'YNbttn1','-or', 'Tag', 'YNbttn2');
            if any([okCancel.Enable])
                newLog_close(okCancel(2))
                if ~any([okCancel.Enable])
                    set(eval(tag),'visible','on')
                    set(fig,'visible','off')
                    dbDate = datetime('now','Format','uuuu-MM-dd');
                    WH_dbDatePicker(dbDate)
                    dp = findobj(fig, 'Type','uidatepicker');
                    dp.Value = dbDate;
                end
            else
                set(eval(tag),'visible','on')
                set(fig,'visible','off')
                dbDate = datetime('now','Format','uuuu-MM-dd');
                WH_dbDatePicker(dbDate)
                dp = findobj(fig, 'Type','uidatepicker');
                dp.Value = dbDate;
            end
            set(findobj('Type','uicheckbox','Tag','category'),'Value', 1);
        elseif strcmp(fig.Tag, 'winLogR') || strcmp(fig.Tag, 'winLogE')
            if isLogEdited
                set(winReview,'visible','on')
                set(fig,'visible','off')
                isLogEdited = false;
            else
                set(eval(tag),'visible','on')
                set(fig,'visible','off')
            end
        else
            set(eval(tag),'visible','on')
            set(fig,'visible','off')
        end
    end



    function window_LogE(~, ~)
        width_SS = 500;
        height_SS = 530;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        fontSize = 12;
        winLogE = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','winLogE','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon,...
            'WindowButtonDownFcn',@figureClicked,...
            'CloseRequestFcn', @(src,event)clearApp(src),...
            'HitTest','off');
        uilabel(winLogE,...
            'Text', 'Fill in the fields below to register a new electrical job',...
            'Position', [0, 0.91*height_SS, 1*width_SS, 40],...
            'FontSize', 17,...
            'FontColor', 'black',...
            'FontName', 'Times New Roman',...
            'FontWeight', 'Bold',...
            'BackgroundColor', 'white',...
            'HorizontalAlignment', 'center', 'Tag', 'Title');
        tabgp = uitabgroup(winLogE, 'Position', [30, 50, width_SS-55, height_SS-100]);
        tabsTitles = {'Description','Flashlight','Lantern','Equipment','Materials','Signboard','Lines','Danger','Other'};
        for k = 1:numel(tabsTitles)
            tab{k} = uitab(tabgp,'Title',tabsTitles{k},'BackgroundColor','white','Scrollable','on');
        end
        set([tab{1}],'Scrollable','off')
        yH = 460;
        left_x0 = 0.00*width_SS;
        up_y0 = 0.8900*(height_SS-100);
        h0 = 0.05*yH;
        w0 = 0.499*(width_SS-55)-0;
        dy = 15;
        y = 0;
        textFieldIndex = [1:10, 13:16];
        texts = {'Work Order Number';'Supervising Engineer';'Day';'Date';'Work Performed by';...
            'Maintenance Type';'Neighborhood Name';'Street Name';'Street Number';'Technical Team';...
            'Departure Time';'Return Time';'Number of Working Hours';...
            'Image Showing Maintenance';'After Image';'Maintenance Details'};
        for i = 1:numel(texts)
            Y = up_y0-sum(y);
            pos = [left_x0, Y, w0, h0];
            [textField, editField] = addTextField(i, texts{i}, tab{1}, pos, textFieldIndex, fontSize);
            y = [y h0];
            if i == 1
                editField.Value = num2str(lastLogNumber);
                editField.FontSize = fontSize;
                editField.Editable = 'Off';
            elseif i == 2
                editField.Value = userID;
                editField.FontSize = fontSize;
                editField.Editable = 'Off';
            elseif i ==3
                editField.Value = daysOfWeek{weekday(date)};
                editField.FontSize = fontSize;
                editField.Editable = 'Off';
            elseif i == 4
                pos = editField.Position;
                delete(editField)
                uidatepicker(tab{1},...
                    'Position',pos,...
                    'FontColor', 0.0*[1,1,1],...
                    'BackgroundColor', 0.95*[1,1,1],...
                    'FontSize', fontSize,...
                    'DisplayFormat', 'uuuu-MM-dd',...
                    'Value',datetime('today'),...
                    'Tag', ['editField' num2str(i)],...
                    'ValueChangedFcn', @dateChange);
            elseif i == 5
                pos1 = editField.Position;
                editField.Visible = 'off';
            elseif i == 6
                pos6 = editField.Position;
                editField.Visible = 'off';
            elseif i == 10
                pos10 = editField.Position;
                editField.Visible = 'off';
            elseif any(i == [11 12])
                set(editField, 'ValueChangedFcn', @(~,~)calculateTime(11,12))
            elseif i == 13
                posE = editField.Position;
                delete(editField);
                editField = uieditfield(tab{1},'numeric',...
                    'Position',posE,...
                    'FontSize', fontSize,...
                    'FontColor', 'black',...
                    'BackgroundColor', 1*[1,1,1],...
                    'HorizontalAlignment', 'right',...
                    'Tag', ['editField' num2str(i)], 'Editable','off');
            elseif any(i == 14:15)
                label = {'Before Image', 'After Image'};
                editField.Visible = 'Off';
                if i == 14; pos00 = editField.Position; end
                tags = {'pictureBefore','pictureAfter'};
                idx = strcmp(imagesNames, tags{i-13});
                uibutton(tab{1},'Position', [pos00(1)+(15-i)*0.5*pos00(3), pos00(2), 0.5*pos00(3), pos00(4)], ...
                    'Text', label{i-13},'Tag',tags{i-13},'Icon',image{idx},...
                    'ButtonPushedFcn', @(source,~)selectPicture(source,label{i-13},i-13,i));
                if i == 15
                    textField.Visible = 'Off';
                    pos01 = textField.Position;
                    pos02 = editField.Position;
                end
            elseif i == 16
                set(textField,'Position', [pos01(1)-pos01(3), pos01(2), 2*pos01(3), pos01(4)],...
                    'BackgroundColor', 0.94*[1,1,1], 'HorizontalAlignment', 'center')
                delete(editField)
                uitextarea(tab{1},'Value','',...
                    'Position',[pos02(1), pos02(2)-130-h0, 2*pos02(3)+1, pos02(4)+130],...
                    'FontSize', fontSize,...
                    'FontColor', 'black',...
                    'BackgroundColor', 1*[1,1,1],...
                    'HorizontalAlignment', 'right',...
                    'Tag', ['editField' num2str(i)]);
            end
        end
        items = {'Rafah Municipality', 'Coastal Municipalities Water Utility', ...
            'Electricity Distribution Company', 'Palestinian Telecommunications Company'};
        tag = 'AuthorityCheckBoxTree';
        idx = strcmp(imagesNames, 'arrowDown');
        ButtonH1 = uibutton(tab{1},'Position', pos1, ...
            'Text', 'Select one or more from the list','Tag', 'ToolsButton1',...
            'Icon',image{idx},'ButtonPushedFcn', @(~,~)showCheckBoxes(tag,winLogE));
        tag = 'TypeCheckBoxTree';
        ButtonH2 = uibutton(tab{1},'Position', pos6, ...
            'Text', 'Select one or more from the list','Tag','ToolsButton2',...
            'Icon', image{idx}, 'ButtonPushedFcn', @(~,~)showCheckBoxes(tag,winLogE));
        tag = 'TeamCheckBoxTree';
        ButtonH3 = uibutton(tab{1},'Position', pos10, ...
            'Text', 'Select one or more from the list','Tag', 'ToolsButton3',...
            'Icon', image{idx}, 'ButtonPushedFcn', @(~,~)showCheckBoxes(tag,winLogE));
        CheckBoxTree = uitree(tab{1}, 'checkbox',...
            'Position',[pos1(1), pos1(2)-90, pos1(3), 90],'Visible','Off',...
            'BackgroundColor',[0.9098 0.9922 1.0000],...
            'Tag', 'AuthorityCheckBoxTree',...
            'CheckedNodesChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH1,'editField5'),...
            'SelectionChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH1,'editField5'));
        for n = 1:numel(items)
            uitreenode(CheckBoxTree,'Text',items{n},'Tag','authority');
        end
        items = {'Installing a new spotlight';'Installing a used spotlight';'Installing a new lantern';'Installing a used lantern';'Maintaining a spotlight';'Maintaining a lantern'...
            ;'Installing a lighting panel';'Maintaining a lighting panel';'Maintaining lighting lines';'Removing a hazard';'Other work'};
        CheckBoxTree = uitree(tab{1}, 'checkbox',...
            'Position',[pos6(1), pos6(2)-150, pos6(3), 150],'Visible','Off',...
            'BackgroundColor',[0.9098 0.9922 1.0000],...
            'Tag','TypeCheckBoxTree',...
            'CheckedNodesChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH2,'editField6'),...
            'SelectionChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH2,'editField6'));
        for n = 1:numel(items)
            uitreenode(CheckBoxTree,'Text',items{n},'Tag','type');
        end
        items = {'RQ','AZ','MQ','LA','AH'};
        CheckBoxTree = uitree(tab{1}, 'checkbox',...
            'Position',[pos10(1), pos10(2)-115, pos10(3), 115],'Visible','Off',...
            'BackgroundColor',[0.9098 0.9922 1.0000],...
            'Tag','TeamCheckBoxTree',...
            'CheckedNodesChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH3,'editField10'),...
            'SelectionChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH3,'editField10'));
        for n = 1:numel(items)
            uitreenode(CheckBoxTree,'Text',items{n},'Tag','team');
        end
        texts = {'Description of lighting fixture installation work','Description of lighting lantern installation work','Description of equipment used','Description of materials used','Description of lighting panel installation work','Description of lighting line installation work','Description of hazard removal work','Description of other work'}; categories = tabsTitles;
        for tb = 2:9
            Y = up_y0+1;
            pos = [left_x0, Y, w0, h0];
            text = texts{tb-1};
            [textField, editField] = addTextField(i, text, tab{tb}, pos, textFieldIndex, fontSize);
            editField.Visible = 'off';
            pos0 = textField.Position; pos1 = pos0;
            set(textField, 'Position', [pos0(1)-pos0(3), pos0(2), 2*pos0(3), pos0(4)],...
                'BackgroundColor', 0.94*[1,1,1], 'HorizontalAlignment', 'center')
            delete(editField)
            uitextarea(tab{tb}, 'Value', '',...
                'Position',[pos0(1)-pos0(3)+1, pos0(2)-2.5*h0, 2*pos0(3)-2, 2.5*h0],...
                'FontSize', fontSize,...
                'FontColor', 'black',...
                'BackgroundColor', 1*[1,1,1],...
                'HorizontalAlignment', 'right',...
                'Tag', 'Description');
            EC_data = table2cell(EC_dataTable{1});
            idx = strcmp(EC_data(:,1), categories{tb});
            itemsInfraUnit = EC_data(idx,3);
            itemsInfra = EC_data(idx,4);
            codesInfra = string(EC_data(idx,5));
            itemsInfra = append(itemsInfra, ' - ', itemsInfraUnit);
            y = 3.5*h0+1;
            textFieldIndex = [];
            for n = 1:numel(itemsInfra)
                Y = up_y0-sum(y)-0.0;
                i = i+1;
                pos0 = [left_x0, Y, w0, h0];
                [~, editField] = addTextField(i, itemsInfra{n}, tab{tb}, pos0, textFieldIndex, fontSize);
                editField.Tag = codesInfra{n};
                y = [y h0];
            end
        end
        tags = {'Cancel','OK'};
        names = {'cancel','save'};
        for i = 1:numel(tags)
            idx = strcmp(imagesNames, tags{i});
            uibutton(winLogE, 'push',...
                'Position',[30+(i-1)*(w0+3), 15, w0-3, h0],...
                'Text', names{i},...
                'FontSize', 14,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',['YNbttn' num2str(i)],...
                'BackgroundColor', 'White',...
                "Icon", image{idx}, ...
                'ButtonPushedFcn',@newLog_close);
        end
        idx = strcmp(imagesNames, 'left');
        uibutton(winLogE, 'push',...
            'Position',[10, height_SS-40, 30, 30],...
            'Text', '',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'HorizontalAlignment', 'center',...
            'Tag','winSub',...
            'BackgroundColor', 0.95*[1,1,1],...
            'Icon', image{idx},...
            'ButtonPushedFcn',@Nav_left);
    end



    function window_LogR(~, ~)
        width_SS = 500;
        height_SS = 530;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        fontSize = 12;
        winLogR = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','winLogR','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon,...
            'WindowButtonDownFcn',@figureClicked,...
            'CloseRequestFcn', @(src,event)clearApp(src),...
            'HitTest','off');
        uilabel(winLogR,...
            'Text','Fill in the fields below to record a new road job',...
            'Position',[0, 0.91*height_SS, 1*width_SS, 40],...
            'FontSize', 17,...
            'FontColor', 'black',...
            'FontName', 'Times New Roman',...
            'FontWeight', 'Bold',...
            'BackgroundColor', 'white',...
            'HorizontalAlignment', 'center', 'Tag', 'Title');
        tabgp = uitabgroup(winLogR,'Position',[30, 50, width_SS-55, height_SS-100]);
        tabsTitles = {'Description','Equipment','Road Materials','Infrastructure','Fencing','Signals','Paint','Other'};
        for k = 1:numel(tabsTitles)
            tab{k} = uitab(tabgp,'Title',tabsTitles{k},'BackgroundColor','white','Scrollable','off');
        end
        set([tab{3:end}],'Scrollable','on')
        yH = 460;
        left_x0 = 0.00*width_SS;
        up_y0 = 0.8900*(height_SS-100);
        h0 = 0.05*yH;
        w0 = 0.499*(width_SS-55)-0;
        dy = 15;
        y = 0;
        textFieldIndex = [1:9, 13:16];
        texts = {'Work Order Number';'Supervising Engineer';'Day';'Date';'Work Performed by Agency'...
            ;'Maintenance Type';'Neighborhood Name';'Street Name';'Street Number';'Total Leveling Area - m2'...
            ;'Maintenance Area Length - m';'Maintenance Area Width - m';'Total Maintenance Area - m2'...
            ;'Before Image';'After Image';'Maintenance Details'};
        for i = 1:numel(texts)
            Y = up_y0-sum(y);
            pos = [left_x0, Y, w0, h0];
            [textField, editField] = addTextField(i, texts{i}, tab{1}, pos, textFieldIndex, fontSize);
            y = [y h0];
            if i == 1
                editField.Value = num2str(lastLogNumber);
                editField.FontSize = fontSize;
                editField.Editable = 'Off';
            elseif i == 2
                editField.Value = userID;
                editField.FontSize = fontSize;
                editField.Editable = 'Off';
            elseif i ==3
                editField.Value = daysOfWeek{weekday(date)};
                editField.FontSize = fontSize;
                editField.Editable = 'Off';
            elseif i == 4
                pos = editField.Position;
                delete(editField)
                uidatepicker(tab{1},...
                    'Position',pos,...
                    'FontColor', 0.0*[1,1,1],...
                    'BackgroundColor', 0.95*[1,1,1],...
                    'FontSize', fontSize,...
                    'DisplayFormat', 'uuuu-MM-dd',...
                    'Value',datetime('today'),...
                    'Tag', ['editField' num2str(i)],...
                    'ValueChangedFcn', @dateChange);
            elseif i == 5
                pos1 = editField.Position;
                editField.Visible = 'off';
            elseif i == 6
                pos6 = editField.Position;
                editField.Visible = 'off';
            elseif any(i == [11 12])
                set(editField, 'ValueChangedFcn', @(~,~)calculateArea(11,12))
            elseif i == 13
                posE = editField.Position;
                delete(editField);
                editField = uieditfield(tab{1},'numeric',...
                    'Position',posE,...
                    'FontSize', fontSize,...
                    'FontColor', 'black',...
                    'BackgroundColor', 1*[1,1,1],...
                    'HorizontalAlignment', 'right',...
                    'Tag', ['editField' num2str(i)], 'Editable','off');
            elseif any(i == 14:15)
                label = {'Before Image', 'After Image'};
                editField.Visible = 'Off';
                if i == 14; pos00 = editField.Position; end
                tags = {'pictureBefore','pictureAfter'};
                idx = strcmp(imagesNames, tags{i-13});
                uibutton(tab{1},'Position', [pos00(1)+(15-i)*0.5*pos00(3), pos00(2), 0.5*pos00(3), pos00(4)], ...
                    'Text', label{i-13},'Tag',tags{i-13},'Icon',image{idx},...
                    'ButtonPushedFcn', @(source,~)selectPicture(source,label{i-13},i-13,i));
                if i == 15
                    textField.Visible = 'Off';
                    pos01 = textField.Position;
                    pos02 = editField.Position;
                end
            elseif i == 16
                set(textField,'Position', [pos01(1)-pos01(3), pos01(2), 2*pos01(3), pos01(4)],...
                    'BackgroundColor', 0.94*[1,1,1], 'HorizontalAlignment', 'center')
                delete(editField)
                uitextarea(tab{1},'Value','',...
                    'Position',[pos02(1), pos02(2)-130-h0, 2*pos02(3)+1, pos02(4)+130],...
                    'FontSize', fontSize,...
                    'FontColor', 'black',...
                    'BackgroundColor', 1*[1,1,1],...
                    'HorizontalAlignment', 'right',...
                    'Tag', ['editField' num2str(i)]);
            end
        end
        items = {'Rafah Municipality', 'Coastal Municipalities Water Utility', ...
            'Electricity Distribution Company', 'Palestinian Telecommunications Company'};
        tag = 'AuthorityCheckBoxTree';
        idx = strcmp(imagesNames, 'arrowDown');
        ButtonH1 = uibutton(tab{1},'Position', pos1, ...
            'Text', 'Select one or more from the list','Tag', 'ToolsButton1',...
            'Icon',image{idx},'ButtonPushedFcn', @(~,~)showCheckBoxes(tag,winLogR));
        tag = 'TypeCheckBoxTree';
        ButtonH2 = uibutton(tab{1},'Position', pos6, ...
            'Text', 'Select one or more from the list','Tag','ToolsButton2',...
            'Icon',image{idx},'ButtonPushedFcn', @(~,~)showCheckBoxes(tag,winLogR));
        CheckBoxTree = uitree(tab{1}, 'checkbox',...
            'Position',[pos1(1), pos1(2)-90, pos1(3), 90],'Visible','Off',...
            'BackgroundColor',[0.9098 0.9922 1.0000],...
            'Tag','AuthorityCheckBoxTree',...
            'CheckedNodesChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH1,'editField5'),...
            'SelectionChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH1,'editField5'));
        for n = 1:numel(items)
            uitreenode(CheckBoxTree,'Text',items{n},'Tag','authority');
        end
        items = table2cell(readtable(fullfile(dbNetworkFolder,'data','maintenanceType.txt'),'Delimiter','tab'));
        CheckBoxTree = uitree(tab{1}, 'checkbox',...
            'Position',[pos6(1), pos6(2)-150, pos6(3), 150],'Visible','Off',...
            'BackgroundColor',[0.9098 0.9922 1.0000],...
            'Tag','TypeCheckBoxTree',...
            'CheckedNodesChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH2,'editField6'),...
            'SelectionChangedFcn',@(TreeNode,~)typeSelection(TreeNode,ButtonH2,'editField6'));
        for n = 1:numel(items)
            uitreenode(CheckBoxTree,'Text',items{n},'Tag','type');
        end
        i = i+1;
        text = 'Equipment and Tools Used';
        pos(2) = pos(2)+(i-2)*pos(4);
        [textField, editField] = addTextField(i, text, tab{2}, pos, textFieldIndex, fontSize);
        pos2 = editField.Position;
        delete(editField)
        pos0 = textField.Position;
        set(textField,'Position', [pos0(1)-pos0(3), pos0(2), 2*pos0(3), pos0(4)],...
            'BackgroundColor', 0.94*[1,1,1], 'HorizontalAlignment', 'center')
        idx = strcmp(WH_editedData(:,1), 'Tools');
        items1 = WH_editedData(idx,3);
        tags = string(WH_editedData(idx,2));
        bg = uibuttongroup(tab{2},'Position',[pos2(1), pos2(2)-up_y0, 2*pos2(3), up_y0],...
            'Scrollable','on','BackgroundColor',[0.9798 0.9922 1.0000]);
        wb0 = pos2(3);
        hb0 = 20;
        xb0 = 10;
        yb0 = up_y0 - h0 +10;
        dyb = 25;
        for n = 1:numel(items1)
            uicheckbox(bg, 'Position',[xb0, yb0-(n-1)*dyb, wb0, hb0],...
                'Text', items1{n}, 'Tag', tags{n},'ValueChangedFcn',@(~,~)toolSelection);
        end
        idx = strcmp(WH_editedData(:,1), 'Equipment');
        items2 = WH_editedData(idx,3);
        tags = string(WH_editedData(idx,2));
        for n = 1:numel(items2)
            uicheckbox(bg, 'Position',[xb0+wb0-0, yb0-(n-1)*dyb, wb0-30, hb0],...
                'Text', items2{n}, 'Tag', tags{n}, 'ValueChangedFcn',@(~,~)toolSelection);
        end
        i = i+1;
        text = [ 'Materials used in maintenance'];
        pos(1) = 0;
        [textField, editField] = addTextField(i, text, tab{3}, pos, textFieldIndex, fontSize);
        delete(editField);
        textField.Position(1) = 0;
        pos0 = textField.Position; pos1 = pos0;
        set(textField,'BackgroundColor', 0.94*[1,1,1], 'HorizontalAlignment', 'center')
        pos0 = [pos0(1)+5*pos0(3)/3, pos0(2), pos0(3)/3, pos0(4)];
        uilabel(tab{3},'Text','Field',...
            'Position', pos0,'BackgroundColor', 0.94*[1,1,1], 'HorizontalAlignment', 'center');
        pos0 = [pos0(1)-pos0(3), pos0(2), pos0(3), pos0(4)];
        uilabel(tab{3},'Text','Used',...
            'Position', pos0,'BackgroundColor', 0.94*[1,1,1], 'HorizontalAlignment', 'center');
        pos0 = [pos0(1)-pos0(3), pos0(2), pos0(3), pos0(4)];
        uilabel(tab{3},'Text','New',...
            'Position', pos0,'BackgroundColor', 0.94*[1,1,1], 'HorizontalAlignment', 'center');
        items = {'6 cm Tile - m²','8 cm Tile - m²',...
            '25 cm Front Stone','30 cm Front Stone'};
        codesTilesKerb = {'90000','90002','90001','90003','90007','90006','90010','90009'};
        codesPresent = {'90004','90005','90008','90011'};
        tk = 0; p = 0;
        for no = 1:numel(items)
            pos1(2) = pos1(2)-pos1(4);
            uilabel(tab{3},...
                'Text',[' ' items{no} ': ' ],...
                'Position',pos1,...
                'FontSize', fontSize,...
                'FontColor', 'black',...
                'BackgroundColor', 0.9*[1,1,1],...
                'HorizontalAlignment', 'left',...
                'Tag', ['textField' num2str(i)]);
            for k = 1:3
                pos2 = [pos1(1)+pos(3)+(k-1)/3*(pos1(3)-1), pos1(2), pos1(3)/3, pos1(4)];
                if k == 1
                    p = p+1;
                    tag = codesPresent{p};
                else
                    tk = tk+1;
                    tag = codesTilesKerb{tk};
                end
                uispinner(tab{3},...
                    'Position',pos2,...
                    'FontSize', fontSize,...
                    'FontColor', 'black',...
                    'BackgroundColor', 1*[1,1,1],...
                    'HorizontalAlignment', 'right',...
                    'Limits', [0 Inf], 'Step', 0.1,...
                    'Tag', tag);
                i = i + 1;
            end
        end
        idx = strcmp(WH_editedData(:,1), 'Road Materials');
        itemsRoadsUnit = WH_editedData(idx,4);
        itemsRoads = WH_editedData(idx,3);
        codesRoads = string(WH_editedData(idx,2));
        idx = contains(codesRoads, [codesTilesKerb codesPresent]);
        itemsRoads(idx) = []; itemsRoadsUnit(idx) = []; codesRoads(idx) = [];
        itemsRoads = append(' ', itemsRoads, ' (', itemsRoadsUnit, ')');
        y = (numel(items)+1)*h0;
        textFieldIndex = [];
        for n = 1:numel(itemsRoads)
            Y = up_y0-sum(y);
            pos0 = [left_x0, Y, w0, h0];
            [textField, editField] = addTextField(i, itemsRoads{n}, tab{3}, pos0, textFieldIndex, fontSize);
            editField.Tag = codesRoads{n};
            editField.Position(1) = textField.Position(1);
            textField.Position(1) = 0;
            i = i+1;
            y = [y h0];
        end
        Y = up_y0-sum(y);
        texts = {'Description of sewerage/water works', 'Description of fencing works', 'Description of signs/signs works', 'Description of painting works', 'Description of other works'};
        categories = {'Infrastructure Materials', 'Fencing Materials', 'Sign Materials', 'Painting Materials', 'Seedlings'};
        for tb = 4:8
            text = texts{tb-3};
            [textField, editField] = addTextField(i, text, tab{tb}, pos, textFieldIndex, fontSize);
            editField.Visible = 'off';
            pos0 = textField.Position; pos1 = pos0;
            set(textField, 'Position', [pos0(1)-pos0(3), pos0(2), 2*pos0(3), pos0(4)],...
                'BackgroundColor', 0.94*[1,1,1], 'HorizontalAlignment', 'center')
            delete(editField)
            uitextarea(tab{tb}, 'Value', '',...
                'Position',[pos0(1)-pos0(3)+1, pos0(2)-2.5*h0, 2*pos0(3)-2, 2.5*h0],...
                'FontSize', fontSize,...
                'FontColor', 'black',...
                'BackgroundColor', 1*[1,1,1],...
                'HorizontalAlignment', 'right',...
                'Tag', 'Description');
            idx = strcmp(WH_editedData(:,1), categories{tb-3});
            itemsInfraUnit = WH_editedData(idx,4);
            itemsInfra = WH_editedData(idx,3);
            codesInfra = string(WH_editedData(idx,2));
            itemsInfra = append(' ', itemsInfra, ' (', itemsInfraUnit, ')');
            y = 3.5*h0+1;
            textFieldIndex = [];
            for n = 1:numel(itemsInfra)
                Y = up_y0-sum(y);
                i = i+1;
                pos0 = [left_x0, Y, w0, h0];
                [textField, editField] = addTextField(i, itemsInfra{n}, tab{tb}, pos0, textFieldIndex, fontSize);
                editField.Tag = codesInfra{n};
                editField.Position(1) = textField.Position(1);
                textField.Position(1) = 0;
                y = [y h0];
            end
        end
        tags = {'Cancel','OK'};
        names = {'Cancel','OK'};
        for i = 1:numel(tags)
            idx = strcmp(imagesNames, tags{i});
            uibutton(winLogR, 'push',...
                'Position',[30+(i-1)*(w0+3), 15, w0-3, h0],...
                'Text', names{i},...
                'FontSize', 14,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',['YNbttn' num2str(i)],...
                'BackgroundColor', 'White',...
                "Icon", image{idx}, ...
                'ButtonPushedFcn',@newLog_close);
        end
        idx = strcmp(imagesNames, 'left');
        uibutton(winLogR, 'push',...
            'Position',[10, height_SS-40, 30, 30],...
            'Text', '',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'HorizontalAlignment', 'center',...
            'Tag','winSub',...
            'BackgroundColor', 0.95*[1,1,1],...
            'Icon', image{idx},...
            'ButtonPushedFcn',@Nav_left);
    end



    function [textField, editField] = addTextField(i, text, tab, pos, textFieldIndex, fontSize)
        if i<15
            pos2 = [pos(1)+pos(3), pos(2), pos(3), pos(4)];
        else
            pos2 = pos;
            pos = [pos(1)+pos(3), pos(2), pos(3), pos(4)];
        end
        textField = uilabel(tab,...
            'Text',[text ': ' ],...
            'Position',pos,...
            'FontSize', fontSize,...
            'FontColor', 'black',...
            'BackgroundColor', 0.9*[1,1,1],...
            'HorizontalAlignment', 'left',...
            'Tag', ['textField' num2str(i)]);
        if any(i==textFieldIndex)
            editField = uieditfield(tab,...
                'Position',pos2,...
                'FontSize', fontSize,...
                'FontColor', 'black',...
                'BackgroundColor', 1*[1,1,1],...
                'HorizontalAlignment', 'right',...
                'Tag', ['editField' num2str(i)]);
        else
            editField = uispinner(tab,...
                'Position',pos2,...
                'FontSize', fontSize,...
                'FontColor', 'black',...
                'BackgroundColor', 1*[1,1,1],...
                'HorizontalAlignment', 'right',...
                'Limits', [0 Inf], 'Step', 1,...
                'Tag', ['editField' num2str(i)]);
        end
    end



    function window_review(~, ~)
        width_SS = 700;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        winReview = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','winReview','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon,...
            'CloseRequestFcn', @(src,event)clearApp(src),'WindowButtonDownFcn',@WH_figureClicked);
        x0 = 0.05*width_SS;
        y0 = 0.15*height_SS;
        h = 0.6*height_SS;
        uilabel(winReview,...
            'Text',' ',...
            'Position',[x0, y0+1.1*h, 0.65*width_SS, 0.2*height_SS],...
            'FontSize', 17,...
            'FontColor', 'black',...
            'FontWeight','Bold',...
            'BackgroundColor', 'white',...
            'HorizontalAlignment', 'center','Tag','Title');
        startDate = '2021-12-01';
        endDate = '2022-01-01';
        RD_dataTable = RD_sqlData( 'roads_description', startDate, endDate, 'table');
        RD_savedData = [RD_dataTable.Properties.VariableNames; table2cell(RD_dataTable)];
        RD_editedData = RD_savedData;
        RD_type = RD_categories;
        w = [67, 60, 0, 60, 65];
        RD_table = uitable(winReview,'Data', RD_savedData,...
            'Position',[10, 0.2*y0+17, 0.975*width_SS, 0.8*height_SS-17],...
            'ColumnEditable',false,'Tag', 'RD_table',...
            'ColumnWidth',{w(1), w(2), 'auto', w(4), w(5)},...
            'ColumnName', {},'RowName',{},...
            'CellEditCallback', @RD_editCell,...
            'CellSelectionCallback', @RD_selectCell,...
            'SelectionChangedFcn', @WH_selectionChanged);
        uisRight = uistyle('HorizontalAlignment','right');
        uisBold = uistyle('FontWeight','bold');
        addStyle(RD_table, uisRight)
        addStyle(RD_table, uisBold, 'row',1)



        functionType = {@(~,~)WH_find, @(~,~)showCheckBoxes('CategoryCheckBoxTree',winReview),...
            @(~,~)RD_editLog('log',''), @(~,~)RD_addLog('log',''),@(~,~)RT_exportReport('excel'),@(~,~)RT_exportReport('word')};
        tags = {'find', 'filter','edit', 'add', 'excel', 'word'};
        n = numel(tags);
        for i = 1:n
            idx = strcmp(imagesNames, tags{i});
            uibutton(winReview, 'push',...
                'Position',[width_SS-(n+1-i)*35-3, height_SS-40, 30, 30],...
                'Text', '',...
                'FontSize', 14,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',tags{i},...
                'BackgroundColor', 0.95*[1,1,1],...
                'Icon', image{idx},...
                'ButtonPushedFcn',functionType{i} );
        end
        objH = findobj('Type','uibutton','Tag','find');
        pos = objH.Position;
        uieditfield(winReview,...
            'Value','',...
            'Position',[pos(1)-5-130, height_SS-40, 130, 30],...
            'FontSize', 13,...
            'FontColor', 0*[1,1,1],...
            'BackgroundColor', 0.97*[1,1,1],...
            'HorizontalAlignment', 'right','Tag','find',...
            'visible','off',...
            'ValueChangedFcn', @RD_search);
        idx = strcmp(imagesNames, 'left');
        uibutton(winReview, 'push',...
            'Position',[10, height_SS-40, 30, 30],...
            'Text', '',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'HorizontalAlignment', 'center',...
            'Tag','winSub',...
            'BackgroundColor', 0.95*[1,1,1],...
            'Icon', image{idx},...
            'ButtonPushedFcn',@Nav_left);
        items = RD_categories;
        pos1 = [x0+100, height_SS-40, 0.9*width_SS-200, 30];
        tag = 'CategoryCheckBoxTree';
        items1 = items(1:5);
        bg_height = 180;
        bg = uibuttongroup(winReview,'Position',[pos1(1), pos1(2)-bg_height, pos1(3), bg_height],...
            'Scrollable','off','BackgroundColor',[0.9798 0.9922 1.0000],...
            'Tag',tag, 'Visible','Off');
        wb0 = pos1(3)/2;
        hb0 = 20;
        xb0 = 10;
        yb0 = bg_height - 25;
        dyb = 25;
        shift = 60;
        tablesNames = fields(RD_tableStuct);
        for i = 1:numel(items1)
            cb = uicheckbox(bg, 'Position',[xb0+shift+30, yb0-(i-1)*dyb, wb0, hb0],...
                'Text', items1{i}, 'Tag', tablesNames{i},'Value',0,...
                'ValueChangedFcn',@(~,~)RD_filter(RD_table));
            if i == 1
                set(cb, 'Value', 1)
            end
        end
        items2 = items(6:end);
        for i = 1:numel(items2)
            uicheckbox(bg, 'Position',[xb0+wb0+shift, yb0-(i-1)*dyb, wb0-30, hb0],...
                'Text', items2{i}, 'Tag', tablesNames{i+5},'Value',0,...
                'ValueChangedFcn',@(~,~)RD_filter(RD_table));
        end
        uibutton(bg, 'Position',[1*xb0, 40, pos1(3)-2*xb0, 1],'Enable','off');
        tags = {'selectAll','selectNone'};
        names = {'select all', 'select none'};
        wbutten = 120;
        gbutton = 30;
        x = [pos1(3)/2+gbutton/2, pos1(3)/2-wbutten-gbutton/2 ];
        for i = 1:numel(tags)
            idx = strcmp(imagesNames, tags{i});
            uibutton(bg, 'push',...
                'Position',[x(i), 7, wbutten, 27],...
                'Text', names{i},...
                'FontSize', 13,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',tags{i},...
                'BackgroundColor', 'White',...
                'Icon', image{idx}, ...
                'Enable','on',...
                'ButtonPushedFcn',@(~,~)RD_selectAll(tags{i},RD_table));
        end
        tags = {'Cancel','OK'};
        names = {'Cancel','OK'};
        wbutten = 70;
        gbutton = 5;
        x = [width_SS/2-wbutten-gbutton/2, width_SS/2+gbutton/2 ];
        for i = 1:numel(tags)
            idx = strcmp(imagesNames, tags{i});
            uibutton(winReview, 'push',...
                'Position',[x(i), 3, wbutten, 22],...
                'Text', names{i},...
                'FontSize', 14,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',['YNbttn' num2str(i)],...
                'BackgroundColor', 'White',...
                'Icon', image{idx}, ...
                'Enable','off',...
                'ButtonPushedFcn',@newLog_close);
        end
    end



    function window_warehouse(~, ~)
        width_SS = 700;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        winWH = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','winWH','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon,...
            'CloseRequestFcn', @(src,event)clearApp(src),'WindowButtonDownFcn',@WH_figureClicked);
        x0 = 0.05*width_SS;
        y0 = 0.15*height_SS;
        h = 0.6*height_SS;
        uilabel(winWH,...
            'Text','Warehouse Database',...
            'Position',[x0, y0+1.1*h, 0.9*width_SS, 0.2*height_SS],...
            'FontSize', 17,...
            'FontColor', 'black',...
            'FontWeight','Bold',...
            'BackgroundColor', 'white',...
            'HorizontalAlignment', 'center','Tag','Title');
        WH_dataTable = WH_sqlData();
        T = WH_dataTable{1};
        WH_savedData = [T.Properties.VariableNames; table2cell(T)];
        WH_editedData = WH_savedData;
        if isempty(WH_type)
            WH_type = WHR_categories;
        end
        w = [70, 70, 0, 60, 70, 67];
        WH_table = uitable(winWH,'Data', WH_savedData,...
            'Position',[10, 0.2*y0+17, 0.975*width_SS, 0.8*height_SS-17],...
            'ColumnEditable',[true true(1,5)],'Tag', 'WH_table',...
            'ColumnWidth',{w(6), w(5), 'auto', w(3), w(2), 'auto'},...
            'ColumnName', {},'RowName',{},...
            'ColumnFormat', {'Short','bank','Short','Short','bank','Short'},...
            'CellEditCallback', @WH_editCell,...
            'CellSelectionCallback', @(src,~)WH_selectCell(src),...
            'SelectionChangedFcn', @WH_selectionChanged);
        uisRight = uistyle('HorizontalAlignment','left');
        uisBold = uistyle('FontWeight','bold');
        addStyle(WH_table, uisRight)
        addStyle(WH_table, uisBold, 'row',1)



        functionType = {@(~,~)WH_find, @(~,~)WH_plot, @(~,~)showCheckBoxes('CategoryCheckBoxTree',winWH),...
            @(~,~)WH_omitData, @(~,~)WH_addData(WH_table), @(~,~)WH_saveExcel, @(~,~)WH_saveWord};
        tags = {'find', 'plot', 'filter', 'omit', 'add', 'excel', 'word'};
        n = numel(tags);
        for i = 1:n
            idx = strcmp(imagesNames, tags{i});
            uibutton(winWH, 'push',...
                'Position',[width_SS-(n+1-i)*35-3, height_SS-40, 30, 30],...
                'Text', '',...
                'FontSize', 14,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',tags{i},...
                'BackgroundColor', 0.95*[1,1,1],...
                'Icon', image{idx},...
                'ButtonPushedFcn',functionType{i} );
        end
        objH = findobj('Type','uibutton','Tag','find');
        pos = objH.Position;
        uieditfield(winWH,...
            'Value','',...
            'Position',[pos(1)-5-130, height_SS-40, 130, 30],...
            'FontSize', 13,...
            'FontColor', 0*[1,1,1],...
            'BackgroundColor', 0.97*[1,1,1],...
            'HorizontalAlignment', 'right','Tag','find',...
            'visible','off',...
            'ValueChangedFcn', @(source,~)WH_search(source.Value));
        idx = strcmp(imagesNames, 'left');
        uibutton(winWH, 'push',...
            'Position',[10, height_SS-40, 30, 30],...
            'Text', '',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'HorizontalAlignment', 'center',...
            'Tag','winSub',...
            'BackgroundColor', 0.95*[1,1,1],...
            'Icon', image{idx},...
            'ButtonPushedFcn',@Nav_left);
        [~, fname, ~] = fileparts(dbFiles);
        rangeAvailableDates = datetime(fname);
        rangeDates = min(rangeAvailableDates): max(rangeAvailableDates);
        notAvailableDates = rangeDates(~contains(string(rangeDates),string(rangeAvailableDates)));
        uidatepicker(winWH,...
            'Position',[45, height_SS-40, 150, 30],...
            'FontColor', 0.25*[1,1,1],...
            'DisplayFormat', 'uuuu-MM-dd',...
            'Value',datetime('today'),...
            'Limits',[min(rangeAvailableDates), max(rangeAvailableDates)],...
            'DisabledDates', notAvailableDates,...
            'Tag','datePicker1',...
            'ValueChangedFcn', @(source,~)WH_dbDatePicker(source.Value));
        items = WH_type;
        pos1 = [x0+100, height_SS-40, 0.9*width_SS-200, 30];
        tag = 'CategoryCheckBoxTree';
        items1 = items(1:6);
        bg_height = 200;
        bg = uibuttongroup(winWH,'Position',[pos1(1), pos1(2)-bg_height, pos1(3), bg_height],...
            'Scrollable','off','BackgroundColor',[0.9798 0.9922 1.0000],...
            'Tag',tag, 'Visible','Off');
        wb0 = pos1(3)/2;
        hb0 = 20;
        xb0 = 10;
        yb0 = bg_height - 25;
        dyb = 25;
        shift = 60;
        for i = 1:numel(items1)
            uicheckbox(bg, 'Position',[xb0+shift+30, yb0-(i-1)*dyb, wb0, hb0],...
                'Text', items1{i}, 'Tag', 'category','Value',1,...
                'ValueChangedFcn',@(~,~)WH_filter(WH_table));
        end
        items2 = items(7:end);
        for i = 1:numel(items2)
            uicheckbox(bg, 'Position',[xb0+wb0+shift, yb0-(i-1)*dyb, wb0-30, hb0],...
                'Text', items2{i}, 'Tag', 'category','Value',1,...
                'ValueChangedFcn',@(~,~)WH_filter(WH_table));
        end
        uibutton(bg, 'Position',[1*xb0, yb0-numel(items2)*dyb+13, pos1(3)-2*xb0, 1],'Enable','off');
        tags = {'selectAll','selectNone'};
        names = {'Select all','Select none'};
        wbutten = 120;
        gbutton = 30;
        x = [pos1(3)/2+gbutton/2, pos1(3)/2-wbutten-gbutton/2 ];
        for i = 1:numel(tags)
            idx = strcmp(imagesNames, tags{i});
            uibutton(bg, 'push',...
                'Position',[x(i), 6, wbutten, 27],...
                'Text', names{i},...
                'FontSize', 13,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',tags{i},...
                'BackgroundColor', 'White',...
                'Icon', image{idx}, ...
                'Enable','on',...
                'ButtonPushedFcn',@(~,~)WH_selectAll(tags{i},WH_table));
        end
        tags = {'Cancel','OK'};
        names = {'Cancel','OK'};
        wbutten = 70;
        gbutton = 5;
        x = [width_SS/2-wbutten-gbutton/2, width_SS/2+gbutton/2 ];
        for i = 1:numel(tags)
            idx = strcmp(imagesNames, tags{i});
            uibutton(winWH, 'push',...
                'Position',[x(i), 3, wbutten, 22],...
                'Text', names{i},...
                'FontSize', 14,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',['YNbttn' num2str(i)],...
                'BackgroundColor', 'White',...
                'Icon', image{idx}, ...
                'Enable','off',...
                'ButtonPushedFcn',@newLog_close);
        end
    end



    function WH_dbDatePicker(dbDate)
        fig = gcf;
        Hbuttons = findobj(fig, 'Type','uibutton','Tag', 'add','-or', 'Tag', 'omit');
        close(dbConnection)
        if strcmp(char(dbDate), char(datetime('now','Format','uuuu-MM-dd')))
            dbFile = dbNetworkFile;
            set(Hbuttons, 'Enable', 'on');
            set(WH_table,'ColumnEditable',true)
        else
            set(Hbuttons, 'Enable', 'off');
            set(WH_table,'ColumnEditable',false)
            new_DB = append(string(dbDate), '.db');
            dbFile = fullfile(dbNetworkFolder, 'databases',new_DB);
        end
        dbConnection = sqlite(dbFile,'connect');
        WH_dataTable = WH_sqlData();
        T = WH_dataTable{1};
        WH_savedData = [T.Properties.VariableNames; table2cell(T)];
        WH_editedData = WH_savedData;
        WH_tableStyle();
        checkedBoxes = findobj('Type','uicheckbox','Tag','category','Value',1);
        objH = findobj('Type','uieditfield','Tag','find');
        keyword = objH.Value;
        if ~isempty(checkedBoxes)
            WH_filter(0);
        end
        if ~isempty(keyword)
            WH_search(keyword)
        end
    end



    function WH_plot()
        WH_uit = findall(winWH, 'Type', 'uitable');
        dataValues = []; dataNotes = []; dataDates = [];
        if ~isempty(WH_selectedCells)
            firstRow = WH_selectedCells(1);
            if firstRow ~= 1
                dataCell = get(WH_uit, 'Data');
                codeValue = dataCell{firstRow,5};
                itemValue = dataCell{firstRow,4};
                itemUnit = dataCell{firstRow,3};
                for i = 1:length(dbFiles)
                    dbFile = fullfile(dbFilesStruct(i).folder,dbFilesStruct(i).name);
                    dbConnection = sqlite(dbFile,'connect');
                    tableName = 'warehouseTable';
                    Columns = sprintf('"%s", ',string(codeValue));
                    dataCell = fetch(dbConnection,['SELECT Quantity, Notes from ' tableName ' where (Code IN ( ', Columns(1:end-2), ' ))']);
                    if ~isempty(dataCell)
                        dataCell(cellfun('isempty', dataCell) ) = {' '};
                        dataValues = [dataValues; cell2mat(dataCell(:,1))];
                        dataNotes = [dataNotes; string(dataCell(:,2))];
                        [~, dbDate, ~] = fileparts({dbFilesStruct(i).name});
                        dataDates = [dataDates; dbDate];
                    end
                    close(dbConnection)
                end
                dataNotes_filtered = string([]);
                for i = 1:length(dataNotes)
                    if isempty(dataNotes(i)) || strcmp(dataNotes(i), ' ')
                        dataNotes_filtered(i) = "";
                        continue
                    elseif isempty(dataNotes_filtered)
                        dataNotes_filtered(i) = "";
                    elseif dataNotes(i) ~= dataNotes(i-1)
                        dataNotes_filtered(i) = dataNotes(i);
                    else
                        dataNotes_filtered(i) = "";
                    end
                end
                h = plot(datetime(dataDates),dataValues(:,1),'parent',winPlot.CurrentAxes,'LineWidth',1.0,'Color',[0,0.5,.5]);
                obj = findobj(winPlot,'Type','uilabel');
                set(obj,'Text',append(" ",itemValue, " "))
                ylabel(winPlot.CurrentAxes,append("Quantity: ", itemUnit),'FontWeight','bold')
                xt = datetime(dataDates)-10;
                yt = dataValues(:,1);
                str = dataNotes_filtered;
                xtickformat(winPlot.CurrentAxes,'MMM');
                text(winPlot.CurrentAxes,xt,yt,str,"Color",[0 0.4470 0.7410]);
                fig = gcf;
                [winPlot.CurrentAxes.YLimMode] = deal('auto');
                [winPlot.CurrentAxes.XLimMode] = deal('auto');
                pos = fig.Position;
                if ~winPlotMove
                    set(winPlot,'Position',fig.Position);
                    winPlotMove = true;
                end
                set(winPlot,'Visible', 'On');
            end
        end
    end



    function WH_find()
        fig = gcf;
        objH(1) = findobj(fig,'Type','uieditfield','Tag', 'find');
        objH(2) = findobj(fig,'Type','uilabel','Tag', 'Title');
        if get(objH(1),'visible')
            set(objH(1),'visible','off')
            set(objH(2),'visible','on')
        else
            set(objH(1),'visible','on')
            set(objH(2),'visible','off')
        end
    end



    function WH_search(keyword)
        if WH_dataChanged; WH_filter(); end
        checkedBoxes = findobj('Type','uicheckbox','Tag','category');
        if ~isempty(keyword)
            rows = zeros(size(WH_editedData,1),1);
            for i = [1 2 3 4 6]
                cell = WH_editedData(:,i);
                if i == 2; cell = string(cell); end
                row = contains(cell,keyword);
                rows = rows | row;
            end
            rows(1) = 0;
            dataCell = WH_editedData(rows,:);
            C = [headingsWarehouse; dataCell];
            set(WH_table, 'Data', C)
            WH_searchRows = find(rows);
            set(checkedBoxes, 'Value',0);
            WH_searchActive = true;
        else
            set(WH_table, 'Data', WH_editedData)
            WH_searchRows = [];
            set(checkedBoxes, 'Value',1);
            WH_searchActive = false;
        end
    end



    function WH_saveExcel()
        [file,path,index] = uiputfile('Report.xlsx');
        if index == 1
            try
                fig= gcf;
                dataT = findobj(fig,'Type','uitable');
                data = get(dataT, 'Data');
                if strcmp(dataT.Tag, 'WH_table')
                    sheetName = 'Projects Warehouse';
                    writecell(data,append(path,file),'Sheet',sheetName,'WriteMode','overwritesheet');
                else
                    writematrix(data,append(path,file),'WriteMode','overwritesheet')
                end
            catch
                message = {'The following error occured:','','The file may already be open in Excel.','Close the file or select a different name.'};
                uiconfirm(gcf, message,'Error',...
                    'Icon','error', 'Options', {'OK'});
            end
        end
    end



    function WH_saveWord()
        makeDOMCompilable();
        import mlreportgen.dom.*
        [file,fileFolder,~] = uiputfile('Report.docx');
        if file ~= 0
            [~,fileName,~] = fileparts(file);
            fig= gcf;
            dataT = findobj(fig,'Type','uitable');
            data = get(dataT, 'Data');
            if strcmp(dataT.Tag, 'WH_table')
                docTemplate = 'reportTemplate_Portrait_A4.dotx';
            else
                docTemplate = 'reportTemplate_Landscape_A4.dotx';
            end
            template = fullfile(CurrentPath,'assets','templates',docTemplate);
            rpt = Document([fileFolder, fileName],'docx',template);
            open(rpt);
            append(rpt,Heading(1,'','Heading 1'));
            h1 = Heading1('Projects Warehouse Table');
            h1.HAlign = 'center';
            append(rpt,h1);
            if size(data,1) == 1
                data(2,:) = cell(1,size(data,2));
            end
            tableOut = append(rpt,data);
            tableOut.Border = 'solid';
            tableOut.ColSep = 'solid';
            tableOut.RowSep = 'solid';
            close(rpt);
        end
    end



    function WH_omitData()
        WH_uit = findall(winWH, 'Type', 'uitable');
        if ~isempty(WH_selectedCells)
            firstRow = WH_selectedCells(1);
            lastRow = WH_selectedCells(2);
            dataCell = get(WH_uit, 'Data');
            dataCell(firstRow:lastRow,:)=[];
            set(WH_uit, 'Data', dataCell)
            set(findall(winWH, 'Tag', 'YNbttn1'),'Enable','On')
            set(findall(winWH, 'Tag', 'YNbttn2'),'Enable','On')
            WH_table.Selection = [];
            WH_selectedCells = [];
            WH_dataChanged = true;
            if WH_searchActive
                WH_omitRows = [WH_omitRows; WH_searchRows(firstRow-1:lastRow-1)];
                WH_omitRows(WH_omitRows > size(WH_editedData,1)) = [];
                WH_searchRows(firstRow-1:lastRow-1) = [];
            end
        end
        WH_tableStyle();
    end



    function WH_selectCell(src)
        fig = gcf;
        set(findall(fig, 'Tag', 'CategoryCheckBoxTree'),'visible','Off')
    end



    function WH_selectionChanged(~,event)
        selection = event.Selection;
        if ~isempty(selection)
            firstRow = selection(1,1);
            lastRow = selection(end,1);
            firstColumn = selection(1,2);
            lastColumn = selection(end,2);
            WH_selectedCells = [firstRow,lastRow,firstColumn,lastColumn];
            if (firstRow ~= 1 ) && firstColumn == 1 && lastColumn == 5
            else
            end
        end
    end



    function WH_addData(~)
        if isempty(WH_selectedCells)
            WH_selectedCells = 1;
        end
        currentRow = WH_selectedCells(1);
        newCell = {'Status',0.0,'Unit','Description',0000,'Materials'};
        dataCell = get(WH_table, 'Data');
        if size(dataCell,1) > 1
            upperCell = dataCell(1:currentRow,:);
            lowerCell = dataCell(currentRow+1:end,:);
            C = [upperCell; newCell; lowerCell];
        else
            upperCell = dataCell(1,:);
            C = [upperCell; newCell];
        end
        set(WH_table, 'Data', C);
        pos = WH_table.Position;
        set(findall(winWH, 'Tag', 'YNbttn1'),'Enable','On')
        set(findall(winWH, 'Tag', 'YNbttn2'),'Enable','On')
        WH_dataChanged = true;
        if WH_searchActive
            n = size(WH_editedData,1)+1;
            if any(WH_searchRows == n)
                WH_searchRows = [max(WH_searchRows)+1; WH_searchRows];
            else
                WH_searchRows = [n; WH_searchRows];
            end
        end
        WH_tableStyle();
    end



    function WH_selectAll(tag,~)
        checkedBoxes = findobj('Type','uicheckbox','Tag','category');
        if ~isempty(checkedBoxes)
            switch tag
                case 'selectAll'
                    set(checkedBoxes,'Value',1)
                case 'selectNone'
                    set(checkedBoxes,'Value',0)
            end
            WH_filter(WH_table)
        end
    end



    function WH_filter(~)
        WH_table.Selection = [];
        WH_selectedCells = [];
        checkedBoxes = findobj('Type','uicheckbox','Tag','category','Value',1);
        ButtonH = findall(winWH, 'Tag', 'filter');
        if WH_dataChanged
            WH_displayedDate = get(WH_table,'Data');
            if ~isempty(WH_omitRows) || ~isempty(WH_searchRows)
                WH_editedData(WH_searchRows,:) = WH_displayedDate(2:end,:);
                WH_editedData(WH_omitRows,:) = [];
                WH_searchRows = [];
                WH_omitRows = [];
            elseif ~isempty(WH_type)
                for i = 1:numel(WH_type)
                    idx = strcmp(WH_editedData(:,1), WH_type{i});
                    WH_editedData(idx,:) = [];
                    idx = strcmp(WH_displayedDate(:,1), WH_type{i});
                    WH_editedData = [WH_editedData; WH_displayedDate(idx,:)];
                end
            else
                type = WHR_categories;
                for i = 1:numel(type)
                    idx = strcmp(WH_displayedDate(:,1), type{i});
                    WH_editedData = [WH_editedData; WH_displayedDate(idx,:)];
                end
            end
            WH_dataChanged = false;
            WH_searchActive = false;
        end
        if ~isempty(checkedBoxes)
            type = {checkedBoxes.Text};
            WH_type = flip(type);
            text = sprintf('%s, ',string(WH_type));
            dataCell = [];
            for i = 1:numel(WH_type)
                idx = strcmp(WH_editedData(:,1), WH_type{i});
                dataCell = [dataCell; WH_editedData(idx,:)];
            end
        else
            dataCell = {};
            WH_type = {};
        end
        C = [headingsWarehouse; dataCell];
        set(WH_table, 'Data', C)
        WH_tableStyle();
    end



    function WH_tableStyle()
        [row1,~] = find(cell2mat(WH_table.Data(2:end,2)) == 0);
        [row2,~] = find(cell2mat(WH_table.Data(2:end,2)) < 0);
        removeStyle(WH_table)
        uisRight = uistyle('HorizontalAlignment','left');
        uisBold = uistyle('FontWeight','bold');
        addStyle(WH_table, uisRight)
        addStyle(WH_table, uisBold, 'row',1)
        WH_redStyle1 = uistyle('BackgroundColor',[244 242 196]/255);
        WH_redStyle2 = uistyle('BackgroundColor',[244,185,138]/255);
        if ~isempty(row1)
            addStyle(WH_table,WH_redStyle1,'row',row1+1)
        end
        if ~isempty(row2)
            addStyle(WH_table,WH_redStyle2,'row',row2+1)
        end
    end



    function WH_editCell(~,event)
        event.PreviousData;
        newValue = event.EditData;
        idx = event.Indices;
        set(findall(winWH, 'Tag', 'YNbttn1'),'Enable','On')
        set(findall(winWH, 'Tag', 'YNbttn2'),'Enable','On')
        WH_dataChanged = true;
        if any(idx(2)==[2,5])
            WH_tableStyle();
        end
    end



    function dataTable = EC_sqlData()
        if ~isempty(dbConnection)
            dataCell = fetch(dbConnection,'SELECT * from warehouseElecTable');
            if ~isempty(dataCell)
                headings = {'Notes','Quantity', 'Unit', 'Item', 'Code', 'Type'};
                dataTable{1} = cell2table(dataCell,'VariableNames',headings);
            end
        end
    end



    function dataTable = WH_sqlData()
        if ~isempty(dbConnection)
            dataCell = fetch(dbConnection,['SELECT * from ' categoryTable]);
            if ~isempty(dataCell)
                dataTable{1} = cell2table(dataCell,'VariableNames',headingsWarehouse);
            end
        end
    end



    function selectPicture(source,title,index,i)
        tabs = findobj(winLogR.Children, 'Type', 'uitab');
        ID = get(findobj(tabs(1).Children, 'Type', 'uieditfield', 'Tag', 'editField1'), 'Value');
        if index == 1
            fileName = [ID 'a'];
        else
            fileName = [ID 'b'];
        end
        [file,path] = uigetfile({'*.png;*.jpg;*.jpeg', 'Images Files: (*.png,*.jpg,*.jpeg)'}, title);
        if file ~=0
            [~, filename, ext] = fileparts(file);
            inputFullFileName = fullfile(path, file);
            outputFullFileName = fullfile(dbNetworkFolder, 'pictures', category, [fileName, ext] );
            copyfile(inputFullFileName, outputFullFileName);
            set(source, 'Text', [filename, ext])
            fig = gcf;
            editField = findall(fig, 'Tag', ['editField' num2str(i)]);
            editField.Value = [fileName, ext];
        end
    end



    function calculateArea(a,b)
        fig = gcf;
        editField1 = findall(fig, 'Tag', ['editField' num2str(a)]);
        editField2 = findall(fig, 'Tag', ['editField' num2str(b)]);
        editField = findall(fig, 'Tag', ['editField' num2str(b+1)]);
        editField.Value = (editField1.Value * editField2.Value);
    end



    function calculateTime(a,b)
        fig = gcf;
        editField1 = findall(fig, 'Tag', ['editField' num2str(a)]);
        editField2 = findall(fig, 'Tag', ['editField' num2str(b)]);
        editField = findall(fig, 'Tag', ['editField' num2str(b+1)]);
        editField.Value = (editField2.Value - editField1.Value);
    end



    function dateChange(~,event)
        fig = gcf;
        editField = findall(fig, 'Tag', 'editField3');
        editField.Value = daysOfWeek{day(event.Value,'dayofweek')};
    end



    function typeSelection(TreeNode,ButtonH,tag)
        items = {TreeNode.Children.Text};
        selectedNode = TreeNode.SelectedNodes.Text;
        r1 = matches(items,selectedNode);
        checkedNodes = TreeNode.CheckedNodes;
        if isempty(checkedNodes)
            TreeNode.CheckedNodes = TreeNode.Children(r1);
        else
            r2 = matches(items,{checkedNodes.Text});
            r3 = matches(selectedNode,{checkedNodes.Text});
            if r3
                r = and(~r1,r2);
            else
                r = or(r1,r2);
            end
            if all(~r)
                TreeNode.CheckedNodes = [];
            else
                TreeNode.CheckedNodes = TreeNode.Children(r);
            end
        end
        h = findall(gcf, 'Tag', tag);
        checkedNodes = TreeNode.CheckedNodes;
        if ~isempty(checkedNodes)
            value = {checkedNodes.Text};
            text = sprintf('%s, ',string(flip(value)));
            set(ButtonH,'Text', text(1:end-2));
            set(h,'Value',text(1:end-2));
        else
            idx = strcmp(imagesNames, 'arrowDown');
            set(ButtonH,'Text', 'Select one or more from the list','Icon',image{idx});
            set(h,'Value','');
        end
    end



    function toolSelection
        checkedBoxes = findobj('Type','uicheckbox','Tag','tool','Value',1);
        h = findall(gcf, 'Tag', 'editField12');
        if ~isempty(checkedBoxes)
            value = {checkedBoxes.Text};
            text = sprintf('%s, ',string(flip(value)));
        else
        end
    end



    function authoritySelection(TreeNode,ButtonH)
        nodes = TreeNode.CheckedNodes;
        h = findall(gcf, 'Tag', 'editField5');
        if ~isempty(nodes)
            value = {nodes.Text};
            text = sprintf('%s, ',string(flip(value)));
            set(ButtonH,'Text', text(1:end-2));
            set(h,'Value',text(1:end-2));
        else
            idx = strcmp(imagesNames, 'arrowDown');
            set(ButtonH,'Text', 'Select one or more from the list','Icon',image{idx});
            set(h,'Value','');
        end
    end



    function showCheckBoxes(tag, fig)
        set(findobj(fig,'Type','uieditfield','Tag', 'find'),'Visible','Off');
        set(findobj(fig,'Type','uilabel','Tag', 'Title'),'Visible','On');
        h = findall(fig, 'Tag', tag);
        h1 = findall(fig, 'Tag', 'TypeCheckBoxTree');
        h2 = findall(fig, 'Tag', 'AuthorityCheckBoxTree');
        h3 = findall(fig, 'Tag', 'TeamCheckBoxTree');
        if get(h,'Visible')
            set(h,'Visible','Off')
        else
            set(h1,'Visible','Off')
            set(h2,'Visible','Off')
            set(h3,'Visible','Off')
            set(h,'Visible','On')
        end
    end



    function figureClicked(fig,~)
        clickedObject = gco(fig);
        if ~isempty(clickedObject)
            clickedObjectTag = clickedObject.Tag;
        else
            clickedObjectTag = 'empty';
        end
        if ~any(strcmp(clickedObjectTag,{'authority','type','team',...
                'AuthorityCheckBoxTree','TypeCheckBoxTree','TeamCheckBoxTree',...
                'ToolsButton1','ToolsButton2','ToolsButton3'}))
            h1 = findall(fig, 'Tag', 'TypeCheckBoxTree');
            h2 = findall(fig, 'Tag', 'AuthorityCheckBoxTree');
            h3 = findall(fig, 'Tag', 'TeamCheckBoxTree');
            if ~isempty(h3)
                if get(h1,'Visible') || get(h2,'Visible') || get(h3,'Visible')
                    set(h1,'Visible','Off')
                    set(h2,'Visible','Off')
                    set(h3,'Visible','Off')
                end
            else
                if get(h1,'Visible') || get(h2,'Visible')
                    set(h1,'Visible','Off')
                    set(h2,'Visible','Off')
                end
            end
        else
            c = class(clickedObject);
            if strcmp(c, 'matlab.ui.container.TreeNode')
                TreeNode = clickedObject.Parent;
                TreeNode.SelectedNodes = [];
            end
        end
    end



    function WH_figureClicked(~,~)
        fig = gcf;
        clickedObject = gco(fig);
        if ~isempty(clickedObject)
            clickedObject.Type;
            clickedObjectTag = clickedObject.Tag;
            if ~any(strcmp(clickedObjectTag,{'category','filter','CategoryCheckBoxTree','selectAll','selectNone'}))
                if ~strcmp(clickedObject.Type, 'uicheckbox')
                    h = findall(fig, 'Tag', 'CategoryCheckBoxTree');
                    if get(h,'Visible')
                        set(h,'Visible','Off')
                    end
                end
            end
        end
    end



    function newLog_close(hObject, ~)
        option = hObject.Text;
        fig = gcf;
        if option == "OK"
            message = {'Do you want to save the entered data?','','Click OK to save it to the database','Click Cancel to return to the previous page'};
            selection = uiconfirm(gcf, message,'Confirm saving the entered data to the database',...
                'Options',{'Cancel','OK'}, 'Icon','success');
            switch selection
                case "OK"
                    if strcmp(get(gcf,'Tag'),'winReview')
                        set(findall(fig, 'Tag', 'YNbttn1'),'Enable','Off')
                        set(findall(fig, 'Tag', 'YNbttn2'),'Enable','Off')
                        for k = 1:size(RD_editedCells,2)
                            tableName = RD_editedCells{1,k};
                            colNumber = RD_editedCells{2,k};
                            ID = RD_editedCells{3,k};
                            newValue = RD_editedCells{4,k};
                            colName = RD_tableStuct.(tableName)(colNumber);
                            sqlStatement = append('SELECT "', string(colName), '" FROM ', string(tableName), ' WHERE (ID = ', string(ID), ')');
                            oldValue_Log = cell2mat(fetch(dbConnection,sqlStatement));
                            sqlStatement = append('UPDATE ', string(tableName), ' SET "', string(colName), '" = ''', string(newValue), ''' WHERE ID = ', string(ID));
                            exec(dbConnection,sqlStatement);
                            [ismemb, pos] = ismember(string(colName), string(WH_editedData(:,2)));
                            if ~strcmp(tableName, 'roads_description') && ismemb
                                oldValue_WH = cell2mat(WH_editedData(pos,2));
                                updatedValue = double(oldValue_WH) - (str2double(newValue) - double(oldValue_Log));
                                sqlStatement = append('UPDATE warehouseTable SET "Quantity" = ''', string(updatedValue), ''' WHERE Code = ', string(colName));
                                exec(dbConnection,sqlStatement);
                            end
                        end
                        WH_dataTable = WH_sqlData();
                        T = WH_dataTable{1};
                        WH_savedData = [T.Properties.VariableNames; table2cell(T)];
                        WH_editedData = WH_savedData;
                        set(WH_table, 'Data', WH_savedData)
                    elseif strcmp(get(fig,'Tag'),'winWH')
                        d = uiprogressdlg(fig,'Title','Saving input data','Indeterminate','on');
                        drawnow
                        set(findall(fig, 'Tag', 'YNbttn1'),'Enable','Off')
                        set(findall(fig, 'Tag', 'YNbttn2'),'Enable','Off')
                        checkboxes = findobj(winWH,'Type','uicheckbox','Tag','category','Value',1);
                        if isempty(checkboxes)
                            set(findobj(winWH,'Type','uicheckbox','Tag','category'),'Value',1);
                        end
                        if WH_dataChanged
                            WH_filter()
                        end
                        WH_savedData = WH_editedData;
                        exec(dbConnection,['DROP TABLE IF EXISTS ' categoryTable]);
                        createWarehouseTable = ['create table ' categoryTable ' ' ...
                            '(Category VARCHAR,' ...
                            'Code DOUBLE,' ...
                            'Item VARCHAR, ' ...
                            'Unit VARCHAR,' ...
                            'Quantity INTEGER,' ...
                            'Notes VARCHAR)'];
                        exec(dbConnection,createWarehouseTable)
                        headingsWarehouseEng = {'Category', 'Code', 'Item', 'Unit', 'Quantity', 'Notes'};
                        insert(dbConnection,categoryTable, headingsWarehouseEng, WH_savedData(2:end,:));
                        switch categoryTable
                            case 'warehouseTable'
                                window_LogR(0,0);
                                lastLogNumber = cell2mat(fetch(dbConnection,'SELECT ID FROM roads_description order by ID desc limit 1')) + 1;
                                if isempty(lastLogNumber)
                                    lastLogNumber = 1;
                                end
                                set(findobj(winLogR,'Tag', 'editField1'),'Value', num2str(lastLogNumber));
                                RD_saveLog;
                                tablesNames = fields(RD_tableStuct);
                            case 'warehouseElecTable'
                                window_LogE(0,0);
                                lastLogNumber = cell2mat(fetch(dbConnection,'SELECT ID FROM elec_description order by ID desc limit 1')) + 1;
                                if isempty(lastLogNumber)
                                    lastLogNumber = 1;
                                end
                                set(findobj(winLogR,'Tag', 'editField1'),'Value', num2str(lastLogNumber));
                                tablesNames = fields(EC_tableStuct);
                        end
                        for j = 1:numel(tablesNames)
                            sqlStatement = ['DELETE FROM ' tablesNames{j} ' WHERE ID = ' num2str(lastLogNumber)];
                            exec(dbConnection,sqlStatement)
                        end
                        close(d)
                    else
                        d = uiprogressdlg(fig,'Title','Saving input data','Indeterminate','on');
                        drawnow
                        if strcmp(categoryTable, 'warehouseTable')
                            RD_saveLog
                            RD_updateWHtable
                        else
                            EC_saveLog
                            EC_updateWHtable
                        end
                        close(d)
                        if isLogEdited
                            Nav_right(reviewType, '')
                            isLogEdited = false;
                        else
                            set(winSub, 'visible','on')
                        end
                        set(gcf, 'visible','off')
                        if strcmp(categoryTable, 'warehouseTable')
                            RD_clearLog;
                        else
                            EC_clearLog;
                        end
                    end
            end
        else
            message = {'Do you want to cancel the entered data?','','Click OK to confirm the cancellation','Click Cancel to return to the previous page'};
            selection = uiconfirm(gcf, message,'Confirm cancellation of saving changes to the database',...
                'Options',{'Cancel','OK'}, 'Icon','warning');
            switch selection
                case 'OK'
                    if strcmp(get(fig,'Tag'),'winReview')
                        set(findall(fig, 'Tag', 'YNbttn1'),'Enable','Off')
                        set(findall(fig, 'Tag', 'YNbttn2'),'Enable','Off')
                        set(RD_table,'Data', RD_savedData)
                    elseif strcmp(get(gcf,'Tag'),'winWH')
                        set(findall(winWH, 'Tag', 'YNbttn1'),'Enable','Off')
                        set(findall(winWH, 'Tag', 'YNbttn2'),'Enable','Off')
                        set(WH_table,'Data', WH_savedData)
                        WH_tableStyle()
                    elseif strcmp(get(gcf,'Tag'),'winLogR') || strcmp(get(gcf,'Tag'),'winLogE')
                        if isLogEdited
                            Nav_right(reviewType, '')
                            isLogEdited = false;
                        else
                            set(winSub, 'visible','on')
                        end
                        if strcmp(categoryTable, 'warehouseTable')
                            RD_clearLog;
                        else
                            EC_clearLog
                        end
                        set(gcf, 'visible','off')
                    else
                        set(winSub, 'visible','on')
                        set(gcf, 'visible','off')
                    end
            end
        end
    end



    function [dataCell, columnsNames] = RD_sqlData(tableName, startDate, endDate, type)
        if strcmp(categoryTable, 'warehouseElecTable')
            tablesNames = fields(EC_tableStuct);
            columnsNames = EC_tableStuctAr.(tableName);
            tName = 'elec_description';
        else
            tablesNames = fields(RD_tableStuct);
            columnsNames = RD_tableStuctAr.(tableName);
            tName = 'roads_description';
        end
        dataCell = [];
        if ~isempty(dbConnection)
            dataCell = fetch(dbConnection,['SELECT * from ' tName ' where (Date BETWEEN ''' startDate ''' AND ''' endDate ''') order by ID desc']);
            if ~strcmp(tableName,tablesNames{1}) && ~isempty(dataCell)
                ID = dataCell(:,1);
                IDs = sprintf('%s,',string(ID));
                IDs = ['(',IDs(1:end-1),')'];
                dataCell = fetch(dbConnection,['SELECT * from ' tableName ' where (ID IN ', IDs, ' ) order by ID desc']);
            end
        end
        if isempty(dataCell)
            dataCell = cell(1,numel(columnsNames));
        end
        if strcmp(type, 'table')
            dataCell = cell2table(dataCell,'VariableNames',columnsNames);
        end
    end



    function RD_selectAll(tag,~)
        fig = gcf;
        checkedBoxes = findobj(fig, 'Type','uicheckbox');
        if ~isempty(checkedBoxes)
            switch tag
                case 'selectAll'
                    set(checkedBoxes,'Value',1);
                case 'selectNone'
                    set(checkedBoxes,'Value',0);
            end
            RD_filter(RD_table);
        end
    end



    function RD_search(source, ~)
        if RD_dataChanged; RD_filter(); end
        keyword = source.Value;
        checkedBoxes = findobj('Type','uicheckbox','Tag','category');
        if ~isempty(keyword)
            rows = zeros(size(RD_editedData,1),1);
            for i = 1:size(RD_editedData,2)
                cell = string(RD_editedData(:,i));
                row = contains(cell,keyword);
                rows = rows | row;
            end
            dataCell = RD_editedData(rows,:);
            C = [RD_editedData(1,:); dataCell];
            set(RD_table, 'Data', C)
            RD_searchRows = find(rows);
            set(checkedBoxes, 'Value',0);
            RD_searchActive = true;
        else
            set(RD_table, 'Data', RD_editedData)
            RD_searchRows = [];
            set(checkedBoxes, 'Value',1);
            RD_searchActive = false;
        end
    end



    function RD_filter(~)
        RD_table.Selection = [];
        RD_selectedCells = [];
        checkedBoxes = findobj(winReview,'Type','uicheckbox','Value',1);
        set(RD_table,'Data',RD_editedData);
        RD_displayedDate = get(RD_table,'Data');
        if RD_dataChanged
            RD_displayedDate = get(RD_table,'Data');
            if ~isempty(RD_omitRows) || ~isempty(RD_searchRows)
                RD_editedData(RD_searchRows,:) = RD_displayedDate(2:end,:);
                RD_editedData(RD_omitRows,:) = [];
                RD_searchRows = [];
                RD_omitRows = [];
            elseif ~isempty(RD_type)
                for i = 1:numel(RD_type)
                    idx = strcmp(RD_editedData(:,5), RD_type{i});
                    RD_editedData(idx,:) = [];
                    idx = strcmp(RD_displayedDate(:,5), RD_type{i});
                    RD_editedData = [RD_editedData; RD_displayedDate(idx,:)];
                end
            else
                type = RD_categories;
                for i = 1:numel(type)
                    idx = strcmp(RD_displayedDate(:,5), type{i});
                    RD_editedData = [RD_editedData; RD_displayedDate(idx,:)];
                end
            end
            RD_dataChanged = false;
            RD_searchActive = false;
        end
        if ~isempty(checkedBoxes)
            type = {checkedBoxes.Tag};
            RD_type = flip(type);
            dataCell = [];
            if size(RD_displayedDate,1) > 1
                if isempty(RD_displayedDate{2,1}); a = false; else; a = true; end
            else
                a = false;
            end
            if ~isempty(dbConnection) && a
                for i = 1:numel(RD_type)
                    [dataCell{i}, columnsNames{i}] = RD_sqlData(RD_type{i}, startDate, endDate, 'cell');
                end
                dataCell = cat(2, dataCell{:});
                columnsNames = cat(2, columnsNames{:});
            else
                for i = 1:numel(RD_type)
                    tableName = RD_type{i};
                    columnsNames{i} = RD_tableStuctAr.(tableName);
                end
                columnsNames = cat(2, columnsNames{:});
            end
        else
            dataCell = {};
            RD_type = {};
            columnsNames = RD_editedData(1,:);
        end
        C = [columnsNames; dataCell];
        set(RD_table, 'Data', C)
        RD_table.Selection = [1,1];
        idx = ~contains(string(columnsNames),["Number","Engineer","Before Image","After Image"]);
        set(RD_table, 'ColumnEditable', idx)
    end



    function EC_updateWHtable
        fig = gcf;
        tabs = findobj(fig.Children, 'Type', 'uitab');
        objValues = []; objCodes = [];
        for t = 2:numel(tabs)-1
            editfields = flip(findobj(tabs(t).Children, 'Type', 'uispinner', '-not',{'Tag','present'}));
            objValues = [objValues {editfields.Value}];
            objCodes = [objCodes {editfields.Tag}];
        end
        if ~isempty(dbConnection)
            WH_dataTable = WH_sqlData();
            T = WH_dataTable{1};
            WH_savedData = [T.Properties.VariableNames; table2cell(T)];
            WH_editedData = WH_savedData;
            WH_editedData0 = WH_editedData(2:end,:);
            cellCode = string(WH_editedData0(:,2));
            cellQty = WH_editedData0(:,5);
            [ismemb, idx] = ismember(objCodes,cellCode);
            if isLogEdited && ~isempty(oldLogValues)
                newCellQty = double(cell2mat(cellQty(idx(ismemb)))) - ( double(cell2mat(objValues')) - double(cell2mat(oldLogValues')) );
                oldLogValues = [];
            else
                newCellQty = double(cell2mat(cellQty(idx(ismemb)))) - double(cell2mat(objValues'));
            end
            WH_editedData0(idx(ismemb),2) = num2cell(newCellQty);
            WH_editedData = [WH_editedData(1,:); WH_editedData0];
            WH_savedData = WH_editedData;
            exec(dbConnection,'DROP TABLE IF EXISTS warehouseElecTable');
            createWarehouseTable = ['create table warehouseElecTable ' ...
                '(Category VARCHAR,' ...
                'Code DOUBLE,' ...
                'Item VARCHAR, ' ...
                'Unit VARCHAR,' ...
                'Quantity INTEGER,' ...
                'Notes VARCHAR)'];
            exec(dbConnection,createWarehouseTable)
            headingsWarehouseEng = {'Category', 'Code', 'Item', 'Unit', 'Quantity', 'Notes'};
            insert(dbConnection,'warehouseElecTable', headingsWarehouseEng, WH_savedData(2:end,:));
            set(WH_table, 'Data', WH_savedData);
        end
    end



    function RD_updateWHtable
        fig = gcf;
        tabs = findobj(fig.Children, 'Type', 'uitab');
        objValues = [];
        objCodes = [];
        for t = 3:numel(tabs)
            editfields = flip(findobj(tabs(t).Children, 'Type', 'uispinner'));
            objValues = [objValues {editfields.Value}];
            objCodes = [objCodes {editfields.Tag}];
        end
        if ~isempty(dbConnection)
            WH_dataTable = WH_sqlData();
            T = WH_dataTable{1};
            WH_savedData = [T.Properties.VariableNames; table2cell(T)];
            WH_editedData = WH_savedData;
            WH_editedData0 = WH_editedData(2:end,:);
            cellCode = string(WH_editedData0(:,2));
            cellQty = WH_editedData0(:,5);
            [ismemb, idx_in_cellCode] = ismember(objCodes, cellCode);
            v1_common_qty = double(cell2mat(cellQty(idx_in_cellCode(ismemb))));
            v2_common_values = double(cell2mat(objValues(ismemb)')); % Transpose objValues for cell2mat
            v3_common_values = [];
            if isLogEdited && ~isempty(oldLogValues)
                v3_common_values = double(cell2mat(oldLogValues(ismemb)'));
            end
            if isLogEdited && ~isempty(v3_common_values)
                newCellQty = v1_common_qty - (v2_common_values - v3_common_values);
                oldLogValues = [];
            else
                newCellQty = v1_common_qty - v2_common_values;
            end
            WH_editedData0(idx_in_cellCode(ismemb),5) = num2cell(newCellQty);
            WH_editedData = [WH_savedData(1,:); WH_editedData0];
            WH_savedData = WH_editedData;
            exec(dbConnection,'DROP TABLE IF EXISTS warehouseTable');
            createWarehouseTable = ['create table warehouseTable ' ...
                '(Category VARCHAR,' ...
                'Code DOUBLE,' ...
                'Item VARCHAR, ' ...
                'Unit VARCHAR,' ...
                'Quantity INTEGER,' ...
                'Notes VARCHAR)'];
            exec(dbConnection,createWarehouseTable)
            headingsWarehouseEng = {'Category', 'Code', 'Item', 'Unit', 'Quantity', 'Notes'};
            insert(dbConnection,'warehouseTable', headingsWarehouseEng, WH_savedData(2:end,:));
            set(WH_table, 'Data', WH_savedData);
        end
    end



    function RD_updateWHtable000
        fig = gcf;
        tabs = findobj(fig.Children, 'Type', 'uitab');
        objValues = []; objCodes = [];
        for t = 3:numel(tabs)
            editfields = flip(findobj(tabs(t).Children, 'Type', 'uispinner'));
            objValues = [objValues {editfields.Value}];
            objCodes = [objCodes {editfields.Tag}];
        end
        if ~isempty(dbConnection)
            WH_dataTable = WH_sqlData();
            T = WH_dataTable{1};
            WH_savedData = [T.Properties.VariableNames; table2cell(T)];
            WH_editedData = WH_savedData;
            WH_editedData0 = WH_editedData(2:end,:);
            cellCode = string(WH_editedData0(:,2));
            cellQty = WH_editedData0(:,5);
            [ismemb, idx] = ismember(objCodes,cellCode);
            v1 = double(cell2mat(cellQty(idx(ismemb))));
            v2 = double(cell2mat(objValues'));
            v3 = double(cell2mat(oldLogValues'));
            disp(size(v1))
            disp(size(v2))
            disp(size(v3))
            if size(v1) == size(v2)
                if isLogEdited && ~isempty(oldLogValues)
                    newCellQty = v1 - (v2 - v3);
                    oldLogValues = [];
                else
                    disp(size(double(cell2mat(cellQty(idx(ismemb))))))
                    disp(size(double(cell2mat(objValues'))))
                    newCellQty = v1 - v2;
                end
                WH_editedData0(idx(ismemb),5) = num2cell(newCellQty);
                WH_editedData = [WH_editedData(1,:); WH_editedData0];
                WH_savedData = WH_editedData;
                exec(dbConnection,'DROP TABLE IF EXISTS warehouseTable');
                createWarehouseTable = ['create table warehouseTable ' ...
                    '(Category VARCHAR,' ...
                    'Code DOUBLE,' ...
                    'Item VARCHAR, ' ...
                    'Unit VARCHAR,' ...
                    'Quantity INTEGER,' ...
                    'Notes VARCHAR)'];
                exec(dbConnection,createWarehouseTable)
                headingsWarehouseEng = {'Category', 'Code', 'Item', 'Unit', 'Quantity', 'Notes'};
                insert(dbConnection,'warehouseTable', headingsWarehouseEng, WH_savedData(2:end,:));
                set(WH_table, 'Data', WH_savedData);
            end
        end
    end



    function RD_addLog(~, ~)
        isLogEdited = true;
        Nav_right('log','');
    end



    function RD_editLog(tag,~)
        win = gcf;
        if ~isempty(RD_table.Selection)
            row = RD_table.Selection(1);
            ID = RD_table.Data{row,1};
            if isnumeric(ID)
                isLogEdited = true;
                if strcmp(categoryTable, 'warehouseElecTable')
                    EC_fillLog(ID);
                    set(winLogE, 'visible','on')
                else
                    RD_fillLog(ID);
                    set(winLogR, 'visible','on')
                end
                set(win, 'visible','off')
            end
        end
    end



    function EC_fillLog(ID)
        tablesNames = fields(EC_tableStuct);
        columnsNames = struct2cell(EC_tableStuct);
        tabs = findobj(winLogE.Children, 'Type', 'uitab');
        tab2Type = {'machine', 'tool'};
        idx = strcmp(WH_editedData(:,1), 'Tools');
        idx = strcmp(WH_editedData(:,1), 'Equipment');
        items2 = WH_editedData(idx,4);
        tags = string(WH_editedData(idx,5));
        j = 0;
        for t = 1:numel(tabs)
            j = j + 1;
            tableName = tablesNames{j};
            columnsName = columnsNames{j};
            data = fetch(dbConnection, ['SELECT * FROM ' tableName ' WHERE (ID =' num2str(ID) ')']);
            editfields = flip(findobj(tabs(t).Children, '-not',{'Type','uibutton','-or','Type','uilabel','-or','Type','uitreenode','-or','Type','uicheckboxtree'}));
            fieldsTags = {editfields.Tag};
            n = numel(editfields);
            ToolsButtons = {'ToolsButton1','ToolsButton2','ToolsButton3'};
            TreeType = {'AuthorityCheckBoxTree','TypeCheckBoxTree','TeamCheckBoxTree'};
            ii = 0;
            for i = 1:n
                if t == 1 && any(i == [1, 9])
                    editfields(i).Value = num2str(data{i});
                elseif t == 1 && i == 4
                    editfields(i).Value = datetime(data{i});
                elseif t == 1 && any(i == [5, 6, 10])
                    ii = ii + 1;
                    editfields(i).Value = data{i};
                    objBttn = findobj('Type', 'uibutton','Tag',ToolsButtons{ii});
                    if strcmp(data{i},' ') || isempty(data{i})
                        set(objBttn, 'Text', 'Select one or more from the list');
                    else
                        set(objBttn, 'Text', data{i})
                        objTree = findobj('Type', 'uicheckboxtree', 'Tag',TreeType{ii});
                        txt = {objTree(1).Children.Text};
                        t0 = objBttn(1).Text;
                        prt = [];
                        x0 = find(t0 == ',');
                        if ~isempty(x0)
                            x = [1 x0 length(t0)];
                            for i = 1:numel(x)-1
                                if i ==1
                                    prt{i} = t0(x(i):x(i+1)-1);
                                elseif i == numel(x)-1
                                    prt{i} = t0(x(i)+2:x(i+1)-0);
                                else
                                    prt{i} = t0(x(i)+2:x(i+1)-1);
                                end
                            end
                        else
                            prt{1} = t0;
                        end
                        idx = matches(txt,prt);
                        o = objTree(1);
                        o.CheckedNodes = o.Children(idx);
                    end
                elseif t == 1 && any(i == [14, 15])
                    editfields(i).Value = data{i};
                    label = {'Before Image', 'After Image'};
                    tags = {'pictureBefore','pictureAfter'};
                    objBttn = findobj('Type','uibutton','Tag', tags{i-13});
                    if strcmp(data{i}, ' ') || isempty(data{i})
                        objBttn(1).Text = label{i-13};
                    else
                        objBttn(1).Text = data{i};
                    end
                elseif t == 1
                    editfields(i).Value = data{i};
                elseif t > 1
                    idx = strcmp(fieldsTags, columnsName(i+1));
                    editfields(idx).Value = data{i+1};
                else
                    editfields(i).Value = string(data{i+1});
                end
            end
        end
        oldLogValues = [];
        for t = 2:numel(tabs)-1
            editfields = flip(findobj(tabs(t).Children, 'Type', 'uispinner', '-not',{'Tag','present'}));
            oldLogValues = [oldLogValues {editfields.Value}];
        end
    end



    function RD_fillLog(ID)
        tablesNames = fields(RD_tableStuct);
        columnsNames = struct2cell(RD_tableStuct);
        tabs = findobj(winLogR.Children, 'Type', 'uitab');
        tab2Type = {'machine', 'tool'};
        idx = strcmp(WH_editedData(:,1), 'Tools');
        idx = strcmp(WH_editedData(:,1), 'Equipment');
        items2 = WH_editedData(idx,4);
        tags = string(WH_editedData(idx,5));
        j = 0;
        for t = [1, 2, 2, 3:numel(tabs)]
            j = j + 1;
            tableName = tablesNames{j};
            columnsName = columnsNames{j};
            data = fetch(dbConnection, ['SELECT * FROM ' tableName ' WHERE (ID =' num2str(ID) ')']);
            if t == 2
                editfields = flip(findobj(tabs(t).Children, 'Type','uicheckbox'));
                pos = cell2mat(get(editfields, 'Position'));
                if j == 2
                    idx = pos(:,1) > 20;
                else
                    idx = pos(:,1) < 20;
                end
                editfields = editfields(idx);
                fieldsTags = {editfields.Tag};
            else
                editfields = flip(findobj(tabs(t).Children, '-not',{'Type','uibutton','-or','Type','uilabel','-or','Type','uitreenode','-or','Type','uicheckboxtree'}));
                fieldsTags = {editfields.Tag};
            end
            n = numel(editfields);
            ToolsButtons = {'ToolsButton1','ToolsButton2'};
            TreeType = {'AuthorityCheckBoxTree','TypeCheckBoxTree'};
            for i = 1:n
                if t == 1 && any(i == [1, 9])
                    editfields(i).Value = num2str(data{i});
                elseif t == 1 && i == 4
                    editfields(i).Value = datetime(data{i});
                elseif t == 1 && any(i == [5, 6])
                    editfields(i).Value = data{i};
                    objBttn = findobj('Type', 'uibutton','Tag',ToolsButtons{i-4});
                    if strcmp(data{i},' ') || isempty(data{i})
                        set(objBttn, 'Text', 'Select one or more from the list');
                    else
                        set(objBttn, 'Text', data{i})
                        objTree = findobj('Type', 'uicheckboxtree', 'Tag',TreeType{i-4});
                        txt = {objTree(1).Children.Text};
                        t0 = objBttn(1).Text;
                        prt = [];
                        x0 = find(t0 == ',');
                        if ~isempty(x0)
                            x = [1 x0 length(t0)];
                            for i = 1:numel(x)-1
                                if i ==1
                                    prt{i} = t0(x(i):x(i+1)-1);
                                elseif i == numel(x)-1
                                    prt{i} = t0(x(i)+2:x(i+1)-0);
                                else
                                    prt{i} = t0(x(i)+2:x(i+1)-1);
                                end
                            end
                        else
                            prt{1} = t0;
                        end
                        idx = matches(txt,prt);
                        o = objTree(1);
                        o.CheckedNodes = o.Children(idx);
                    end
                elseif t == 1 && any(i == [14, 15])
                    editfields(i).Value = data{i};
                    label = {'Before Image', 'After Image'};
                    tags = {'pictureBefore','pictureAfter'};
                    objBttn = findobj('Type','uibutton','Tag', tags{i-13});
                    if strcmp(data{i}, ' ') || isempty(data{i})
                        objBttn(1).Text = label{i-13};
                    else
                        objBttn(1).Text = data{i};
                    end
                elseif t == 1
                    editfields(i).Value = data{i};
                elseif t > 1
                    idx = strcmp(fieldsTags, columnsName(i+1));
                    editfields(idx).Value = data{i+1};
                else
                    editfields(i).Value = data{i+1};
                end
            end
        end
        oldLogValues = [];
        for t = 3:numel(tabs)
            editfields = flip(findobj(tabs(t).Children, 'Type', 'uispinner', '-not',{'Tag','present'}));
            oldLogValues = [oldLogValues {editfields.Value}];
        end
    end



    function EC_clearLog
        tabs = findobj(winLogE.Children, 'Type', 'uitab');
        j = 0;
        for t = 1:numel(tabs)
            j = j + 1;
            if t == 1
                HButtons = findobj(tabs(t).Children, 'Type','uibutton');
                idx = strcmp(imagesNames, 'arrowDown');
                set(HButtons([1,2,3]),'Text', 'Select one or more from the list',...
                    'Icon',image{idx});
                label = {'Before Image', 'After Image'};
                set(HButtons(4),'Text', label{2})
                set(HButtons(5),'Text', label{1})
                HcheckBoxes = findobj(tabs(t).Children, 'Type','uicheckboxtree');
                set(HcheckBoxes, 'CheckedNodes', [])
            end
            editfields = flip(findobj(tabs(t).Children, '-not',{'Type','uibutton','-or','Type','uilabel','-or','Type','uitreenode','-or','Type','uicheckboxtree'}));
            for i = 1:numel(editfields)
                val = editfields(i).Value;
                if t == 1 && i == 2
                    editfields(i).Value = userID;
                elseif t == 1 && i == 3
                    editfields(i).Value = daysOfWeek{weekday(date)};
                elseif isnumeric(val)
                    editfields(i).Value = 0;
                elseif isdatetime(val)
                    editfields(i).Value = datetime('now','Format','uuuu-MM-dd');
                elseif islogical(val)
                    editfields(i).Value = false;
                else
                    editfields(i).Value = '';
                end
            end
        end
    end



    function RD_clearLog
        tabs = findobj(winLogR.Children, 'Type', 'uitab');
        j = 0;
        for t = [1, 2, 2, 3:numel(tabs)]
            j = j + 1;
            if t == 1
                HButtons = findobj(tabs(t).Children, 'Type','uibutton');
                idx = strcmp(imagesNames, 'arrowDown');
                set(HButtons([1,2]),'Text', 'Select one or more from the list',...
                    'Icon',image{idx});
                label = {'Before Image', 'After Image'};
                set(HButtons(3),'Text', label{2})
                set(HButtons(4),'Text', label{1})
                HcheckBoxes = findobj(tabs(t).Children, 'Type','uicheckboxtree');
                set(HcheckBoxes, 'CheckedNodes', [])
            end
            if t == 2
                editfields = flip(findobj(tabs(t).Children, 'Type','uicheckbox'));
            else
                editfields = flip(findobj(tabs(t).Children, '-not',{'Type','uibutton','-or','Type','uilabel','-or','Type','uitreenode','-or','Type','uicheckboxtree'}));
            end
            for i = 1:numel(editfields)
                val = editfields(i).Value;
                if t == 1 && i == 2
                    editfields(i).Value = userID;
                elseif t == 1 && i == 3
                    editfields(i).Value = daysOfWeek{weekday(date)};
                elseif isnumeric(val)
                    editfields(i).Value = 0;
                elseif isdatetime(val)
                    editfields(i).Value = datetime('now','Format','uuuu-MM-dd');
                elseif islogical(val)
                    editfields(i).Value = false;
                else
                    editfields(i).Value = '';
                end
            end
        end
    end



    function EC_saveLog
        tablesNames = fields(EC_tableStuct);
        columnsNames = struct2cell(EC_tableStuct);
        tabs = findobj(winLogE.Children, 'Type', 'uitab');
        j = 0;
        for t = 1:numel(tabs)
            j = j + 1;
            IDs = cell2mat(fetch(dbConnection,'SELECT ID FROM elec_description'));
            ID = str2double(findobj(tabs(1).Children,'Tag', 'editField1').Value);
            if any(ID == IDs)
                sqlStatement = ['DELETE FROM ' tablesNames{j} ' WHERE ID = ' num2str(ID)];
                exec(dbConnection,sqlStatement)
            end
            editfields = flip(findobj(tabs(t).Children, '-not',{'Type','uibutton','-or','Type','uilabel','-or','Type','uitreenode','-or','Type','uicheckboxtree'}));
            newRow = cell(1,numel(editfields));
            tags = cell(1,numel(editfields));
            for i = 1:numel(editfields)
                objValue = editfields(i).Value;
                tag = editfields(i).Tag;
                if t == 1 && i == 1
                    objValue = str2double(objValue);
                elseif t == 1 && i == 4
                    objValue = char(editfields(i).Value);
                end
                if isempty(objValue)
                    objValue = '';
                elseif iscell(objValue) && numel(objValue) == 1 && isempty(objValue{1,1})
                    objValue = '';
                elseif iscell(objValue)
                    objValue = sprintf('%s ', string(objValue));
                end
                newRow{i} = objValue;
                tags{i} = tag;
            end
            newColumns = columnsNames{j};
            if ~isempty(dbConnection)
                if t ~= 1
                    ID = str2double(findobj(tabs(1).Children,'Tag', 'editField1').Value);
                    newRow = [ID, newRow];
                    newColumns = ["ID", tags];
                    oldColumns = columnsNames{j};
                    if ~isequal(newColumns,oldColumns)
                        RD_alterTable(tablesNames{j}, newColumns,oldColumns, newRow);
                        continue
                    end
                end
                insert(dbConnection, tablesNames{j}, append('"', newColumns, '"'), newRow);
            end
        end
    end



    function RD_saveLog
        tablesNames = fields(RD_tableStuct);
        columnsNames = struct2cell(RD_tableStuct);
        tabs = findobj(winLogR.Children, 'Type', 'uitab');
        j = 0;
        for t = [1, 2, 2, 3:numel(tabs)]
            j = j + 1;
            IDs = cell2mat(fetch(dbConnection,'SELECT ID FROM roads_description'));
            ID = str2double(findobj(tabs(1).Children,'Tag', 'editField1').Value);
            if any(ID == IDs)
                sqlStatement = ['DELETE FROM ' tablesNames{j} ' WHERE ID = ' num2str(ID)];
                exec(dbConnection,sqlStatement)
            end
            if t == 2
                editfields = flip(findobj(tabs(t).Children, 'Type','uicheckbox'));
                pos = cell2mat(get(editfields, 'Position'));
                if j == 2
                    idx = pos(:,1) > 20;
                else
                    idx = pos(:,1) < 20;
                end
                editfields = editfields(idx);
            else
                editfields = flip(findobj(tabs(t).Children, '-not',{'Type','uibutton','-or','Type','uilabel','-or','Type','uitreenode','-or','Type','uicheckboxtree'}));
            end
            newRow = cell(1,numel(editfields));
            tags = cell(1,numel(editfields));
            for i = 1:numel(editfields)
                if t == 2
                    objValue = double(editfields(i).Value);
                    tag = editfields(i).Tag;
                else
                    objValue = editfields(i).Value;
                    tag = editfields(i).Tag;
                end
                if t == 1 && i == 1
                    objValue = str2double(objValue);
                elseif t == 1 && i == 4
                    objValue = char(editfields(i).Value);
                end
                if isempty(objValue)
                    objValue = '';
                elseif iscell(objValue) && numel(objValue) == 1 && isempty(objValue{1,1})
                    objValue = '';
                elseif iscell(objValue)
                    objValue = sprintf('%s ', string(objValue));
                end
                newRow{i} = objValue;
                tags{i} = tag;
            end
            newColumns = columnsNames{j};
            if ~isempty(dbConnection)
                if t ~= 1
                    ID = str2double(findobj(tabs(1).Children,'Tag', 'editField1').Value);
                    newRow = [ID, newRow];
                    newColumns = ["ID", tags];
                    oldColumns = columnsNames{j};
                    if ~isequal(newColumns,oldColumns)
                        RD_alterTable(tablesNames{j}, newColumns,oldColumns, newRow);
                        continue
                    end
                end
                insert(dbConnection, tablesNames{j}, append('"', newColumns, '"'), newRow);
            end
        end
    end



    function RD_alterTable(tableName, newColumns, oldColumns, newRow)
        oldTable = fetch(dbConnection,['SELECT * from ', tableName]);
        fullColumns = unique([oldColumns, newColumns],"stable");
        rowN = oldTable(end,:);
        for i = 1:numel(rowN)
            if isnumeric(rowN{i})
                rowN{i} = 0;
            else
                rowN{i} = '';
            end
        end
        if numel(fullColumns) == numel(oldColumns)
            [~, idx] = ismember(newColumns, oldColumns);
            rowN(idx) = newRow;
            newTable = [oldTable; rowN];
        else
            [a, ~] = size(oldTable);
            n = abs(numel(fullColumns) - numel(oldColumns));
            zerosColumn = {};
            zerosNumColumn = [repmat({double(0)},a,1)];
            zerosStrColumn = [repmat({''},a,1)];
            [val, idx] =setdiff(newColumns, oldColumns);
            for i = 1:n
                if isnumeric(newRow{idx(i)})
                    zerosColumn = [zerosColumn zerosNumColumn];
                else
                    zerosColumn = [zerosColumn zerosStrColumn];
                end
            end
            zeroRow = [rowN repmat({double(0)},1,n)];
            newTable = [ oldTable, zerosColumn; zeroRow];
            [idx2, pos] = ismember(newColumns,fullColumns);
            newTable(a+1,pos) = newRow(idx2);
            T1 = cell2table(newTable);
            T1.Properties.VariableNames = fullColumns;
            for i = 1:numel(val)
                newColumnName = val{i};
                alterTable = ['ALTER TABLE ', tableName, ' ADD "' newColumnName '" DOUBLE'];
                exec(dbConnection,alterTable)
            end
        end
        deleteTable = ['DELETE FROM ' tableName];
        exec(dbConnection,deleteTable)
        insert(dbConnection, tableName, append('"', fullColumns, '"'), newTable);
        newTableX = fetch(dbConnection,['SELECT * from ', tableName]);
        T2 = cell2table(newTableX);
        T2.Properties.VariableNames = fullColumns;
        if strcmp(categoryTable, 'warehouseTable')
            RD_tableStuct.(tableName) = fullColumns;
            save(RD_tablePath, 'RD_tableStuct')
            cellCode = string(WH_editedData(:,2));
            cellItem = WH_editedData(:,3);
            [ismemb, idx] = ismember(fullColumns, cellCode);
            fullColumns(ismemb) = cellItem(idx(ismemb));
            fullColumns(1) = "ID";
            RD_tableStuctAr.(tableName) = fullColumns;
            save(RD_tablePathAr, 'RD_tableStuctAr')
        else
            EC_tableStuct.(tableName) = fullColumns;
            save(EC_tablePath, 'EC_tableStuct')
            cellCode = string(WH_editedData(:,2));
            cellItem = WH_editedData(:,3);
            [ismemb, idx] = ismember(fullColumns, cellCode);
            fullColumns(ismemb) = cellItem(idx(ismemb));
            fullColumns(1) = "ID";
            EC_tableStuctAr.(tableName) = fullColumns;
            save(EC_tablePathAr, 'EC_tableStuctAr')
        end
    end



    function RD_editCell(~,event)
        fig = gcf;
        newData = event.NewData;
        cell = event.Indices;
        set(findall(fig, 'Tag', 'YNbttn1'),'Enable','On')
        set(findall(fig, 'Tag', 'YNbttn2'),'Enable','On')
        RD_dataChanged = true;
        checkboxes = findobj(fig,'Type','uicheckbox','Value',1);
        checkedTables = flip({checkboxes.Tag});
        col = cell(2);
        ID = event.Source.Data(cell(1),1);
        if iscell(ID)
            ID = double(cell2mat(ID));
        else
            ID = str2num(ID);
        end
        for i = 1:numel(checkedTables)
            No(i) = numel(RD_tableStuct.(checkedTables{i}));
            sumNo = sum(No);
            if col <= sumNo
                tableName = checkedTables{i};
                RD_tableStuctAr.(tableName){col};
                break
            end
        end
        c = true;
        newCell = {tableName; col; ID; newData};
        for i = 1:size(RD_editedCells,2)
            if isequal(newCell(1:3), RD_editedCells(1:3,i))
                RD_editedCells(4,i) = newCell(4);
                c = false;
            end
        end
        if c == true
            RD_editedCells{1,end+1} = newCell{1};
            RD_editedCells{2,end} = newCell{2};
            RD_editedCells{3,end} = newCell{3};
            RD_editedCells{4,end} = newCell{4};
        end
    end



    function RD_selectCell(src, event)
        fig = gcf;
        set(findall(fig, 'Tag', 'CategoryCheckBoxTree'),'visible','Off')
        ind = event.Indices;
        if isempty(ind); return; end
        cellValue = RD_table.Data(ind(1),ind(2));
        if ~isempty(cellValue) && ~strcmp(cellValue, " ")
            col = event.Indices(2);
            row = event.Indices(1);
            pause(0.5);
            if strcmpi(fig.SelectionType, 'open')
                if any(col == [14,15]) && row ~= 1
                    imageName = src.Data{row,col};
                    if ~isempty(imageName)
                        uifigure('HandleVisibility', 'on','Visible','on', 'Color', 'White',...
                            'Position',fig.Position,...
                            'Tag','winPicture','MenuBar', 'none','Resize','off',...
                            'Name',appName,'NumberTitle','off','Icon', windowIcon);
                        imshow(fullfile(dbNetworkFolder, 'pictures', category, imageName),'InitialMagnification','fit');
                        src.Selection = [];
                    end
                end
            else
                if any(event.Indices(2) == [14,15])
                end
            end
        else
        end
    end



    function saveLog
        if strcmp(category,'roads')
            tableName = 'roadsTable';
            fieldsNames = headingsRoads;
        elseif strcmp(category,'buildings')
            tableName = 'buildingsTable';
            fieldsNames = headingsBuildings;
        else
            tableName = 'electricityTable';
            fieldsNames = headingsElectricity;
        end
        for i = 1:numel(fieldsNames)
            obj = findobj(winLogR.Children,"Tag", append("editField", num2str(i)));
            if ~isempty(obj)
                objValue = obj.Value;
                if i == 1
                    objValue = str2double(objValue);
                end
                if isempty(objValue) && strcmp(obj.Type, 'uieditfield')
                    objValue = '';
                else
                    objValue = 0;
                end
                newLog{i} = objValue;
            end
        end
        if ~isempty(dbConnection)
            insert(dbConnection, tableName, fieldsNames, newLog);
        end
    end



    function window_report(~, ~)
        width_SS = 700;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        winReport = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','winReport','MenuBar', 'none','Resize','off',...
            'Name',appName,'NumberTitle','off','Icon', windowIcon,...
            'CloseRequestFcn', @(src,event)clearApp(src));
        n = 4;
        g = 10;
        x0 = 50;
        w = (width_SS - 2*x0 - (n-1)*g)/n;
        h = 0.45*height_SS;
        y0 = height_SS-h-25;
        x0 = x0-10;
        uilabel(winReport,...
            'Text', 'Report on Works entries or Warehouse database',...
            'Position',[3, height_SS-60, 1*width_SS, 0.2*height_SS],...
            'FontSize', 20,...
            'FontWeight','Bold',...
            'FontColor', 'black',...
            'BackgroundColor', 'white',...
            'HorizontalAlignment', 'center');
        idx = strcmp(imagesNames, 'left');
        uibutton(winReport, 'push',...
            'Position',[10, height_SS-40, 30, 30],...
            'Text', '',...
            'FontSize', 14,...
            'FontColor', 'black',...
            'HorizontalAlignment', 'center',...
            'Tag','winSub',...
            'BackgroundColor', 0.95*[1,1,1],...
            'Icon', image{idx},...
            'ButtonPushedFcn',@Nav_left);
        tag = {'roads', 'electricity', 'warehouse', 'reports','works'};
        ww = 150; cx0 = 10;
        idx = strcmp(imagesNames, tag{5});
        stWH = uibutton(winReport, 'state',...
            'Position',[width_SS-ww-cx0, 13, ww, 2*h-50],...
            'Text', '',...
            'FontSize', 10,...
            'FontColor', 'red',...
            'HorizontalAlignment', 'center',...
            'Tag',imagesNames{idx},...
            'BackgroundColor', 0.95*[1,1,1],...
            'ValueChangedFcn', @RT_stateButtn,...
            "Icon", image{idx});
        idx = strcmp(imagesNames, tag{3});
        stWorks = uibutton(winReport, 'state',...
            'Position',[width_SS-2*(ww+cx0), 13, ww, 2*h-50],...
            'Text', '',...
            'FontSize', 10,...
            'FontColor', 'red',...
            'HorizontalAlignment', 'center',...
            'Tag',imagesNames{idx},...
            'BackgroundColor', 0.95*[1,1,1],...
            'ValueChangedFcn', @RT_stateButtn,...
            "Icon", image{idx});
        uibutton(winReport, 'state',...
            'Position',[15, 13, 0.5*width_SS, 0.77*height_SS-8],...
            'BackgroundColor', 0.85*[1,1,1],...
            'Enable', 'off');
        dy = 10; dx = 20;
        uilabel(winReport,...
            'Text', 'Start and end dates of the entered work',...
            'Position',[15, height_SS-80-dy, 0.5*width_SS, 0.1*height_SS],...
            'FontSize', 15,...
            'FontWeight','Bold',...
            'FontColor', 'black',...
            'BackgroundColor', 'none',...
            'HorizontalAlignment', 'center');
        uilabel(winReport,...
            'Text','Start date',...
            'Position',[0.5*width_SS-90+dx, height_SS-110-dy, 100, 20],...
            'FontSize', 13,...
            'FontColor', 0.5*[1,1,1],...
            'BackgroundColor', 'none',...
            'HorizontalAlignment', 'left');
        uidatepicker(winReport,...
            'Position',[110, height_SS-110-dy, 150, 22],...
            'FontColor', 0.5*[1,1,1],...
            'DisplayFormat', 'uuuu-MM-dd',...
            'Value',datetime('today'),...
            'Tag','datePicker1');
        uilabel(winReport,...
            'Text','End date',...
            'Position',[0.5*width_SS-90+dx, height_SS-115-4*dy, 100, 20],...
            'FontSize', 13,...
            'FontColor', 0.5*[1,1,1],...
            'BackgroundColor', 'none',...
            'HorizontalAlignment', 'left');
        uidatepicker(winReport,...
            'Position',[110, height_SS-115-4*dy, 150, 22],...
            'FontColor', 0.5*[1,1,1],...
            'DisplayFormat', 'uuuu-MM-dd',...
            'Value',datetime('today'),...
            'Tag','datePicker2');
        uilabel(winReport,...
            'Text', 'Output File Type',...
            'Position',[10, height_SS-70-14*dy, 0.5*width_SS, 0.1*height_SS],...
            'FontSize', 15,...
            'FontWeight','Bold',...
            'FontColor', 'black',...
            'BackgroundColor', 'none',...
            'HorizontalAlignment', 'center');
        tag = {'word','excel', 'word', 'excel'};
        tag0 = {'word','excel', 'word2', 'excel2'};
        func = {@RT_generateReport,@RT_generateReport,@RT_generateReport,@RT_generateReport};
        txt = {'Full Report','Full Report','Summary','Summary'};
        xx = 30+[10 20+w 10 20+w];
        yy = 10+[50 50 10 10];
        txt = append(tag,' ',txt);
        for i = 1:n
            idx = strcmp(imagesNames, tag{i});
            uibutton(winReport, 'push',...
                'Position',[xx(i), yy(i), w, 30],...
                'Text', txt{i},...
                'FontSize', 12,...
                'FontColor', 'black',...
                'FontWeight','Bold',...
                'HorizontalAlignment', 'center',...
                'Tag',tag0{i},...
                'BackgroundColor', 'White',...
                'ButtonPushedFcn', func{i},...
                "Icon", image{idx});
        end
    end



    function RT_stateButtn(~, event)
        fig = gcf;
        value = event.Value;
        tag = event.Source.Tag;
        stateButtnsOn = findobj(fig, 'Type', 'uistatebutton','Value',1);
        if value == 1 && any(strcmp(tag, {'buildings'}))
            event.Source.Value = 0;
        elseif value == 1
            categoryReport{1} = tag;
            idx = strcmp({stateButtnsOn.Tag}, tag);
            if ~all(idx)
                stateButtnsOn(~idx).Value = 0;
            end
        elseif value == 0
            categoryReport = [];
        end
    end



    function RT_exportReport(reportType)
        if strcmp(categoryTable, 'warehouseElecTable')
            tablesNames = fields(EC_tableStuct);
        else
            tablesNames = fields(RD_tableStuct);
        end
        for i = 1:numel(tablesNames)
            t = RD_sqlData(tablesNames{i}, startDate, endDate, 'table');
            t = standardizeMissing(t, {0,' ',''});
            t(:,all(ismissing(t)))=[];
            if size(t,2) == 1
                t(:,:) = [];
            else
                t = fillmissing(t,'constant',0,'DataVariables',@isnumeric);
            end
            dataTable{i} = t;
        end
        if strcmp(reportType,'excel')
            RT_saveExcelReport(0,0)
        elseif strcmp(reportType,'word')
            RT_saveWordReport(0,0)
        end
    end



    function RT_generateReport(hObject, ~, ~)
        reportType = hObject.Tag;
        for i = 1:2
            obj = findobj(winReport.Children,"Tag", append("datePicker", num2str(i)));
            if ~isempty(obj)
                objValue = obj.Value;
                dates{i} = objValue;
            else
                dates{i} = dateToday;
            end
        end
        if isempty(categoryReport)
            message = {'Report preparation error','','No category was selected.','','Choose a category: Maintenance Work, or Projects Warehouse'};
            uiconfirm(gcf, message,'Error',...
                'Icon','error', 'Options', {'OK'});
        else
            startDate = char(min(dates{1},dates{2}));
            endDate = char(max(dates{1},dates{2}));
            dataTable = {};
            switch categoryTable
                case 'warehouseTable'
                    tableStuct = RD_tableStuct;
                otherwise
                    tableStuct = EC_tableStuct;
            end
            switch categoryReport{1}
                case 'works'
                    tablesNames = fields(tableStuct);
                    for i = 1:numel(tablesNames)
                        t = RD_sqlData(tablesNames{i}, startDate, endDate, 'table');
                        t = standardizeMissing(t, {0,' ','',' ',' ',' '});
                        t(:,all(ismissing(t)))=[];
                        if size(t,2) == 1
                            t(:,:) = [];
                        else
                            t = fillmissing(t,'constant',0,'DataVariables',@isnumeric);
                        end
                        dataTable{i} = t;
                    end
                case 'warehouse'
                    dataTable(1) = WH_sqlData();
                otherwise
            end
            if strcmp(reportType,'excel')
                RT_saveExcelReport(0,0)
            elseif strcmp(reportType,'word')
                RT_saveWordReport(0,0)
            elseif strcmp(reportType,'excel2')
                RT_saveExcelExec(0,0)
            elseif strcmp(reportType,'word2')
                RT_saveWordExec(0,0)
            end
        end
    end



    function RT_saveExcelExec(~,~)
        [file,path,index] = uiputfile('Report.xlsx');
        if index == 1
            switch categoryReport{1}
                case 'roads'
                    tablesNames{1} = 'Roadworks Summary';
                    data = RT_getDataExec();
                otherwise
                    tablesNames{1} = 'Projects Warehouse';
                    data = dataTable;
            end
            startIndex = 1;
            for i = 1 : numel(data)
                try
                    endIndex = startIndex + size(data{i},1);
                    if strcmp(class(data{i}), 'table') || strcmp(categoryReport{1}, 'warehouse')
                        writetable(data{i},append(path,file),'FileType','spreadsheet',...
                            'Sheet',tablesNames{1},...
                            'Range', ['A' num2str(startIndex) ':Z' num2str(endIndex) ]);
                    else
                        writematrix(data{i},append(path,file),'FileType','spreadsheet',...
                            'Sheet',tablesNames{1},...
                            'Range', ['A' num2str(startIndex) ':Z' num2str(endIndex) ]);
                    end
                    startIndex = endIndex+1;
                catch
                    message = {'Error while preparing the report','','The file you want to save may be in use by another program','','Close the file in use and try again'};
                    uiconfirm(gcf, message,'Error',...
                        'Icon','error', 'Options', {'OK'});
                end
            end
        end
    end



    function data = RT_getDataExec()
        data{1} = '*Projects Department - Public Works Section*' ;
        data{2} = ['Summary Report of Works from Period: ' startDate ', to Period: ' endDate] ;
        data{3} = 'Work Completed:' ;
        columnsEn = ["ID", "Leveling_Area", "Damaged_Length", "Damaged_Width", "Damaged_Area"] ;
        columnsAr = [ "Leveling Area - m²", "Maintenance Area Length - m", "Maintenance Area Width - m", "Maintenance Area - m²"] ;
        Columns = sprintf('%s, ',columnsEn);
        tableName = 'roads_description';
        dataCell = fetch(dbConnection,['SELECT ' Columns(1:end-2) ' from ' tableName ' where (Date BETWEEN ''' startDate ''' AND ''' endDate ''') ']);
        if ~isempty(dataCell)
            ID = dataCell(:,1);
            dataSum = cell2mat(dataCell(:,2:end));
            if size(dataSum,1) > 1
                dataSum = sum(dataSum);
            end
            tableCell = [num2cell(columnsAr'), num2cell(dataSum')];
            tableGeneral = array2table(tableCell);
            tableGeneral.Properties.VariableNames = {'Works','Quantities'};
            data{3} = tableGeneral;
            data{4} = " " ;
            data{5} = ['Total materials used in the works from period: ' startDate ', to period: ' endDate];
            tableName = 'roads_roadMat';
            columnsEn = ["412122","421142","90000","90001","90002","90003","90006","90007","90009","90010","90012","90013","90014"];
            columnsAr = ["Ordinary Portland Cement","Lens + Sesame Gradient Rock Aggregate","Used 6cm Tiles","Used 8cm Tiles","New 6cm Tiles","New 8cm Tiles","New 25cm Front Stone","Used 25cm Front Stone","New 30cm Front Stone","Used 30cm Front Stone","Base Course","Hot Asphalt","Cold Asphalt"];
            Columns = sprintf('"%s", ',columnsEn);
            IDs = sprintf('%s,',string(ID));
            IDs = ['(',IDs(1:end-1),')'];
            dataCell = fetch(dbConnection,['SELECT ' Columns(1:end-2) ' from ' tableName ' where (ID IN ', IDs, ' ) order by ID desc']);
            dataSum = cell2mat(dataCell);
            if size(dataSum,1) > 1
                dataSum = sum(dataSum);
            end
            tableCell = [num2cell(columnsAr'), num2cell(dataSum')];
            tableMat = array2table(tableCell);
            tableMat.Properties.VariableNames = {'Works','Quantities'};
            data{6} = tableMat;
        end
    end



    function RT_saveExcelReport(~,~)
        [file,path,index] = uiputfile('Report.xlsx');
        if index == 1
            switch categoryTable
                case 'warehouseElecTable'
                    tablesNames = EC_categories;
                case 'warehouseTable'
                    tablesNames = RD_categories;
                otherwise
                    tablesNames{1} = 'Projects Warehouse';
            end
            for i = 1 : numel(dataTable)
                if size(dataTable{i},2) == 1; continue; end
                try
                    writetable(dataTable{i},append(path,file),'FileType','spreadsheet',...
                        'Sheet',tablesNames{i},'WriteMode','overwritesheet');
                catch
                    message = {'Error while preparing the report','','The file may be in use by another program','','Close the file in use and try again'};
                    uiconfirm(gcf, message,'Error',...
                        'Icon','error', 'Options', {'OK'});
                end
            end
        end
    end



    function RT_saveWordExec(~,~)
        if strcmp(categoryReport{1}, 'warehouse')
            RT_saveWordReport(0,0);
        else
            makeDOMCompilable();
            import mlreportgen.dom.*
            [file,fileFolder,~] = uiputfile('Report.docx');
            if file ~= 0
                [~,fileName,~] = fileparts(file);
                template = fullfile(CurrentPath,'assets','templates','reportTemplate_Portrait_A4.dotx');
                rpt = Document([fileFolder, fileName],'docx',template);
                open(rpt);
                append(rpt,Heading(1,'','Heading 1'));
                h1 = Heading1('Maintenance Report for the Work Done');
                h1.HAlign = 'center';
                append(rpt,h1);
                data = RT_getDataExec();
                iTable = 0;
                for i = 1 : numel(data)
                    if strcmp(class(data{i}),'table')
                        iTable = i;
                        t = FormalTable(data{i});
                        t.Style = [t.Style
                            {NumberFormat("%1.3f"),...
                            Border("none"),...
                            ColSep("none"),...
                            RowSep("none"),...
                            HAlign("center"),...
                            FlowDirection('rtl')}];
                        t.TableEntriesHAlign = "center";
                        headerRow = t.Header.Children(1);
                        headerRow.Style = [headerRow.Style {Bold()}];
                        tableOut = append(rpt,t);
                    else
                        h1 = Heading1(data{i});
                        if i == 1
                            h1.Style={FontFamily('Times New Roman'),Color('teal'),FontSize('18'),Bold(true),Underline('none'),HAlign('center')};
                        else
                            h1.Style={FontFamily('Times New Roman'),Color('deepskyblue'),FontSize('16'),Bold(true),Underline('single'),HAlign('center'),FlowDirection('rtl')};
                        end
                        append(rpt,h1);
                        append(rpt,Heading(1,'','Heading 1'));
                    end
                end
                printedImagePath = [CurrentPath, 'materialSummary.png'];
                if iTable ~= 0
                    dataT = data{iTable};
                    col1 = table2array(dataT(:,2));
                    col2 = table2cell(dataT(:,1));
                    col11 = cell2mat(col1)*10;
                    idx = col11 ~= 0;
                    if sum(col11) ~=0
                        fig = figure('Visible','off');
                        p = pie(col11(idx), 'Parent', fig);
                        ax = gca();
                        lgd = legend(col2(idx));
                        lgd.NumColumns = 3;
                        legend boxoff
                        lgd.Location = 'southoutside';
                        printedImagePath = [fileFolder, 'materialSummary.png'];
                        print(fig, printedImagePath, '-dpng');
                        imageObj = mlreportgen.dom.Image(printedImagePath);
                        imageObj.Style = {ScaleToFit};
                        append(rpt, imageObj);
                    end
                end
                close(rpt);
                if isfile(printedImagePath)
                    delete(printedImagePath)
                end
            end
        end
    end



    function RT_saveWordReport(~,~)
        makeDOMCompilable();
        import mlreportgen.dom.*
        [file,fileFolder,~] = uiputfile('Report.docx');
        if file ~= 0
            [~,fileName,~] = fileparts(file);
            if strcmp(categoryReport{1}, 'warehouse')
                docTemplate = 'reportTemplate_Portrait_A4.dotx';
                head1 = 'Warehouse Table';
            else
                docTemplate = 'reportTemplate_Landscape_A4.dotx';
                head1 = 'Maintenance Report for the Work Done';
                head2 = ' From ';
                head3 = startDate;
                head4 = ' To ';
                head5 = endDate;
                head1 = [head1 head2 head3 head4 head5];
            end
            template = fullfile(CurrentPath,'assets','templates', docTemplate);
            rpt = Document([fileFolder, fileName],'docx',template);
            open(rpt);
            append(rpt,Heading(1,'','Heading 1'));
            h1 = Heading1(head1);
            h1.Style={FontFamily('Times New Roman'),Color('black'),FontSize('18'),Bold(true),Underline('none'),HAlign('center'),FlowDirection('rtl')};
            append(rpt,h1);
            if strcmp(categoryTable, 'warehouseElecTable')
                h1 = Heading1('*Projects Department - Electricity Division*');
                categories = EC_categories;
            else
                h1 = Heading1('*Projects Department - Public Works Division*');
                categories = RD_categories;
            end
            h1.Style={FontFamily('Times New Roman'),Color('teal'),FontSize('16'),Bold(true),Underline('single'),HAlign('center'),FlowDirection('rtl')};
            append(rpt,h1);
            for i = 1 : numel(dataTable)
                if (size(dataTable{i},1) == 1 && all(cellfun(@isempty,dataTable{i}{1,:}))) || size(dataTable{i},2) == 1
                    continue;
                end
                append(rpt,Heading(1,'','Heading 1'));
                txt2 = categories{i};
                h2 = Heading1(txt2);
                h2.Style={FontFamily('Times New Roman'),Color('deepskyblue'),FontSize('16'),Bold(true),Underline('single')};
                h2.HAlign = 'center';
                append(rpt,h2);
                t = FormalTable(dataTable{i});
                t.Style = [t.Style
                    {NumberFormat("%1.3f"),...
                    Border("none"),...
                    ColSep("none"),...
                    RowSep("none"),...
                    HAlign("center"),...
                    FlowDirection('rtl')}];
                t.TableEntriesHAlign = "center";
                headerRow = t.Header.Children(1);
                headerRow.Style = [headerRow.Style {Bold()}];
                tableOut = append(rpt,t);
            end
            close(rpt);
        end
    end



    function win = splash(filename, width, height, factor)
        filename = fullfile(CurrentPath,'assets','icons', filename);
        Width = round(width/factor);
        Height = round(height/factor);
        win = javax.swing.JWindow;
        html=sprintf('<html><img src="file:%s" width="%d" height="%d">', filename, Width, Height);
        label = javax.swing.JLabel(html);
        win.getContentPane.add(label);
        win.setAlwaysOnTop(true);
        win.pack;
        screenSize0 = win.getToolkit.getScreenSize;
        screenHeight0 = screenSize0.height;
        screenWidth0 = screenSize0.width;
        win.setLocation((screenWidth0-Width)/2,(screenHeight0-Height)/2);
        win.show
    end



    function window_login()
        width_SS = 300;
        height_SS = 300;
        clear_X = 0.5*(screenWidth-width_SS);
        clear_Y = 0.5*(screenHeight-height_SS);
        win0 = uifigure('HandleVisibility', 'on','Visible','off', 'Color', 'White',...
            'Position',[clear_X, clear_Y, width_SS, height_SS],...
            'Tag','fig','MenuBar', 'none','Resize','off',...
            'Name','Sign In','NumberTitle','off','Icon', windowIcon,...
            'KeyReleaseFcn',@PSW_keyPress,...
            'CloseRequestFcn', @(src,event)close_password(src));
        y0 = 0.4;
        uiimage(win0,...
            'Position',[0.25*width_SS, y0*height_SS, 0.5*width_SS, 0.5*height_SS],...
            'HorizontalAlignment', 'center',...
            'ImageSource', windowIcon);
        fontSize = 13;
        left_x0 = 20;
        Y = (y0-0.07)*height_SS;
        w0 = 0.5*width_SS - 20;
        h0 = 20;
        labels = {'Employee ID', 'Password'};
        for i = 1:2
            uilabel(win0,...
                'Text',[labels{i} ': ' ],...
                'Position',[left_x0, Y-i*h0, w0, h0],...
                'FontSize', fontSize,...
                'FontColor', 'black',...
                'BackgroundColor', 0.95*[1,1,1],...
                'HorizontalAlignment', 'right',...
                'Tag', ['textField' num2str(i)]);
            editField = uieditfield(win0,...
                'Position',[left_x0+w0, Y-i*h0, w0, h0],...
                'FontSize', fontSize,...
                'FontColor', 'black',...
                'BackgroundColor', 1*[1,1,1],...
                'HorizontalAlignment', 'left',...
                'Tag', ['editField' num2str(i)]);
            if i==2
                set(editField, 'ValueChangingFcn', @password_ValueChanging,'Enable','on')
            end
        end
        imgNames = {'OK','Cancel'};
        tags = {'OK','Cancel'};
        for i = 1:numel(imgNames)
            img = imread(fullfile(CurrentPath,'assets','icons', [imgNames{i} '.png']));
            img = double(img)/255;
            index1 = img(:,:,1) == 0;
            index2 = img(:,:,2) == 0;
            index3 = img(:,:,3) == 0;
            indexWhite = index1+index2+index3==3;
            for idx = 1 : 3
                rgb = img(:,:,idx);
                rgb(indexWhite) = NaN;
                img(:,:,idx) = rgb;
            end
            uibutton(win0, 'push',...
                'Position',[left_x0+(2-i)*(w0+3), 15, w0-3, h0],...
                'Text', tags{i},...
                'FontSize', 13,...
                'FontColor', 'black',...
                'HorizontalAlignment', 'center',...
                'Tag',imgNames{i},...
                'BackgroundColor', 'White',...
                "Icon", img, ...
                'ButtonPushedFcn',@check_password);
        end
    end



    function PSW_keyPress(source, event)
    end



    function close_password(fig)
    end



    function check_password(Source,~)
        if strcmp(Source.Tag, 'Cancel')
            delete(Source)
            close(dbConnection)
            clear dbConnection
            clear global
            close all force
        else
            IDobj = findobj(win0.Children,"Tag", append("editField", num2str(1)));
            PWobj = findobj(win0.Children,"Tag", append("editField", num2str(2)));
            ID = IDobj.Value;
            PW = PWobj.UserData;
            IDs = {'0000'};
            users = {'user'};
            PWs = {'0000'};
            [~, pos] = ismember(ID,IDs);
            if any(strcmp(ID,IDs)) && strcmp(PW,PWs(pos))
                delete(win0);
                userID = users{pos};
                set(winMain, 'Visible', 'on');
            else
                errorCounter = errorCounter + 1;
                if errorCounter >= 3
                    close all force
                else
                    message = {'The following error occurred','',['Incorrect Employee ID or Password. Error:' num2str(errorCounter)] };
                    uiconfirm(win0, message,'Error',...
                        'Icon','error', 'Options', {'OK'});
                end
            end
        end
    end



    function password_ValueChanging(Source, Value)
        password = Source.UserData;
        source = Value.Source;
        key = get(gcf,'currentkey');
        switch key
            case 'backspace'
                password = password(1:end-1);
                SizePass = size(password);
                if SizePass(2) > 0
                    asterisk(1,1:SizePass(2)) = '•';
                    set(source,'Value',asterisk)
                else
                    set(source,'Value','')
                end
                set(source,'Userdata',password)
            case 'return'
                fig = gcf;
                okButton = findobj(fig, 'Type', 'uibutton', 'Tag', 'Ok');
                check_password(okButton,0);
            case 'escape'
            case 'insert'
            case 'delete'
            case 'home'
            case 'pageup'
            case 'pagedown'
            case 'end'
            case 'rightarrow'
            case 'downarrow'
            case 'leftarrow'
            case 'uparrow'
            case 'shift'
            case 'alt'
            case 'control'
            case 'windows'
            otherwise
                password = [password get(gcf,'currentcharacter')];
                SizePass = size(password);
                if SizePass(2) > 0
                    asterisk(1:SizePass(2)) = '•';
                    set(source,'Value',asterisk)
                else
                    set(source,'Value','');
                end
                set(source,'Userdata',password) ;
        end
    end
end
