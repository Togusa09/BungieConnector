// Use this file to write queries to test your data connector
let
    result = BungieConnector.Contents("API KEY", "Character")
	//result = BungieConnector.Contents("1234S")
in
    result