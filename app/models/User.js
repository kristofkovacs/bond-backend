var mongoose = require("mongoose");
var bcrypt = require('bcrypt-nodejs');

var userSchema = mongoose.Schema({

	name: String,
	email: String,
	password: String,
	preferredCategories: [""]

});

// generating a hash
userSchema.methods.generateHash = function(password) {
	return bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
};

// checking if password is valid
userSchema.methods.validPassword = function(password) {
	return bcrypt.compareSync(password, this.local.password);
};

userSchema.statics.upsertFbUser = function(accessToken, refreshToken, profile, cb) {
	var that = this
  console.log(profile);
	return this.findOne({
		"facebookProvider.id": profile.id
	}, function(err, user) {
		// no user was found, lets create a new one
		if (!user) {
			var newUser = new that({
				email: profile.emails[0].value,
				facebookProvider: {
					id: profile.id,
					token: accessToken
				}
			})

			newUser.save(function(error, savedUser) {
				if (error) {
					console.log(error)
				}
				return cb(error, savedUser)
			})
		} else {
			return cb(err, user)
		}
	})
}

mongoose.model("User", userSchema);

module.exports = mongoose.model("User");