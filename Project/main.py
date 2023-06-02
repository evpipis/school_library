from website import create_app

app = create_app()

if __name__ == '__main__': # needed so that the app does not run when imported
    app.run(debug=True, host='localhost', port=5000) # debug needed for reruning the server when we make code changes