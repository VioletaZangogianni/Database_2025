# This python script uses the mysql-connector-python module to easily run multiple queries for our DB project.
# Password needs to be inputted, so the script can connect to our database as root.
# Once the correct password is input, the user is repeatedly asked to input number for query to be run.
# If the number is in [1, 15], the respective query file is found and then run.
#   If the specified SQL Query uses variables, the user is then asked to specify values for them.
#   When the value 0 is input for the first variable, the script defaults to the values in the .sql file.
# If the number is -1, all 15 queries are run, their respective results printed, starting from Q01.sql, all the way to Q15.sql.
#   All variables needed default to the value given in the .sql files.
# If the number 16 is given, user can write a custom query, eg 'SELECT * FROM festival;'
#   User must specify wheen the command ends, with the character ';'
#   User cannot use commands such as 'DROP' or 'DELETE' 





import mysql.connector
import termtables as tt
import getpass
import sys

pwd = getpass.getpass("Please insert password: ")
while(True):
    try:
        mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        password=pwd,
        database="music_festival_ntua"
        )
    except:
        pwd = getpass.getpass("Incorrect password, please try again.\nRemember, you are trying to enter as user root: ")
    else:
        break

cursor = mydb.cursor()

#cursor.execute("SELECT * FROM artist")

while True:
    query = int(input("Which Query to run:"))
    if query == -1:
        for i in range(1, 16):
            print(i)
            file = '..\\sql\\Q' + str(i//10) + str(i%10) + '.sql'

            with open(file) as f:
                comms = f.read().split(';')
                for x in comms: cursor.execute(x, None, True)
            more = True
            while (more):
                res = cursor.fetchall()

                cols = [x[0] for x in cursor.description]
                print(tt.to_string(res,
                           header=cols,
                           style = tt.styles.ascii_thin_double))
                
                more = cursor.nextset()
        break
    elif query < 1 or query > 16:
        break
    elif query == 16:
        while (True):
            comm = '' 
            for line in sys.stdin:
                if ';' in line:
                    comm += line.split(';')[0]
                    break
                comm += line
            for x in comm.split():
                if x.upper() in ['DROP', 'DELETE', 'UPDATE', 'CREATE']:
                    print('No...')
                    sys.exit()
            try:
                cursor.execute(comm)
            except:
                print('Not a valid SQL statement. Please try again.')
            else:
                break
    else:
        file = '..\\sql\\Q' + str(query//10) + str(query%10) + '.sql'
        with open(file) as f:
            
            comms = f.read().split(';')
            if query == 2:
                year = str(int(input("Which year should we check? ")))
                if year != '0':
                    cursor.execute('SET @f_year := ' + year)
                    cursor.fetchall()
                    genre = input("Which genre should we check? ")
                    cursor.execute('SET @genre := \'' + genre + '\'')
                else:
                    cursor.execute(comms[0])
                    cursor.execute(comms[1])
                cursor.fetchall()
                cursor.execute(comms[2])
            elif query == 4:
                art_id = str(int(input("Which artist should we check? ")))
                if art_id == '0':
                    cursor.execute(comms[0])
                else:
                    cursor.execute('SET @artist_id := ' + art_id)
                cursor.execute(comms[1])
            elif query == 6:
                vis_id = str(int(input("Which visitor should we check? ")))
                if vis_id == '0':
                    cursor.execute(comms[0])
                else:
                    cursor.execute('SET @visitor_id := ' + vis_id)
                cursor.execute(comms[1])
            elif query == 8 or query == 9:
                year = str(int(input("Which year should we check? ")))
                if year != '0':
                    month = str(int(input("Which month should we check? ")))
                    day = str(int(input("Which day should we check? ")))
                    date = year + '-' + month + '-' + day
                    cursor.execute('SET @event_date := \'' + date + '\'')
                else:
                    cursor.execute(comms[0])
                cursor.execute(comms[1])
            elif query == 12:
                id = str(int(input("Which festival should we check? ")))
                if id == '0':
                    cursor.execute(comms[0])
                else:
                    cursor.execute('SET @f_id := ' + id)
                cursor.execute(comms[1])
            else:
                for i in comms: cursor.execute(i, None, True)
    
    
    more = True
    while (more):
        res = cursor.fetchall()
        
        cols = [i[0] for i in cursor.description]
        print(tt.to_string(res,
                           header=cols,
                           style = tt.styles.ascii_thin_double))
        more = cursor.nextset()