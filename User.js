var mongoose = require("mongoose")




var UserSchema = mongoose.Schema({
	email: {
		type: String, required: true,
		trim: true, unique: true,
		match: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
	},
	id: String,
	name: String,
	email: String
	// facebookProvider: {
	// 	type: {
	// 		id: String,
	// 		token: String
	// 	},
	// 	select: false
	// }
})

UserSchema.statics.upsertFbUser = function(accessToken, refreshToken, profile, cb) {
	var that = this
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

mongoose.model("User", UserSchema)

module.exports = mongoose.model("User")