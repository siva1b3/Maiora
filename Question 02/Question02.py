from flask import Flask
import requests
import pyodbc

def getData():
    url = "https://v2.jokeapi.dev/joke/Any?amount=10"

    DRIVER = "ODBC Driver 17 for SQL Server"
    SERVER = "QRA-SIVANAGABAB"
    DATABASE = "MyDataBase"
    USERNAME = "naga"
    PASSWORD = "1234"

    try:
        connection = pyodbc.connect(
            f"DRIVER={{{DRIVER}}};"
            f"SERVER={SERVER};"
            f"DATABASE={DATABASE};"
            f"UID={USERNAME};"
            f"PWD={PASSWORD}"
        )
        print("Connection success!")
    except Exception as e:
        print("Connection failed:", e)
    
    cursor = connection.cursor()

    def clean_value(value):
        return value if value not in [None, ""] else None

    insert_query = """
    INSERT INTO Jokes (
        category, type, joke_or_setup, nsfw, political, sexist, safe, lang
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """
    for _ in range(10):
            response = requests.get(url)
            if response.status_code == 200:
                # Parse the JSON response
                json_data = response.json()
                jokes = json_data.get("jokes", [])

                print("10 jokes start")
                # Insert each joke into the SQL Server table
                for joke in jokes:
                    # Determine joke_or_setup content based on type
                    if joke.get("type") == "single":
                        joke_or_setup = clean_value(joke.get("joke"))
                    elif joke.get("type") == "twopart":
                        setup = clean_value(joke.get("setup"))
                        delivery = clean_value(joke.get("delivery"))
                        joke_or_setup = f"{setup} - {delivery}" if setup and delivery else None
                    else:
                        joke_or_setup = None

                    # Execute the query
                    cursor.execute(
                        insert_query,
                        (
                            clean_value(joke.get("category")),
                            clean_value(joke.get("type")),
                            joke_or_setup,
                            clean_value(joke["flags"].get("nsfw")),
                            clean_value(joke["flags"].get("political")),
                            clean_value(joke["flags"].get("sexist")),
                            clean_value(joke.get("safe")),
                            clean_value(joke.get("lang")),
                        )
                    )
            else:
                return {"status": 500, "error": "Internal Server Error"}
        
    connection.commit()
    cursor.close()
    connection.close()

    return {"status": 200, "message": "Jokes successfully inserted into the database"}

app = Flask(__name__)

# Get all items
@app.route('/jokes', methods=['GET'])
def get_items():
    return getData()

if __name__ == '__main__':
    app.run(debug=True)
