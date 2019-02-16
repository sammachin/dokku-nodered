
var settings = require('/app/.node-red/settings.js');
var bcrypt = require('bcryptjs');
const fs = require('fs');
var util = require('util')

var password = bcrypt.hashSync(process.argv[3], 8);
var username = process.argv[2];


settings.adminAuth = {
        type: "credentials",
        users: [{
            username: username,
            password: password,
            permissions: "*"
        }]
}


fs.writeFile('/app/.node-red/settings.js', "module.exports = " + util.inspect(settings, {showHidden: false, depth: null}), (err) => { 
	if (err) throw err;
	console.log("Settings Updated");
});
