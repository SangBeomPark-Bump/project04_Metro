from fastapi import FastAPI
import uvicorn
# import time
import requests

app = FastAPI()

@app.get("/")
def read_root():
    return [{"message": "Hello, World!"}]

@app.get("/chat")
def read_item(userMessage: str):
    # time.sleep(2)

    url = "https://1065-34-125-40-87.ngrok-free.app/"

    # sampleChat = "I want to go to GangNam, let me know when the density is highest."
    # chat = f"query?query={sampleChat}"
    chat = f"query?query={userMessage}"

    response = requests.get(url+chat)

    if response.status_code == 200:
        data = response.json()
        # print(data)
    else:
        print("Error:", response.status_code)


    return [{"message": data['message']}]

if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)