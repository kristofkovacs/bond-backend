var mongoose = require('mongoose');

var ActivitySchema = mongoose.Schema({
  category: { type: mongoose.Schema.Types.ObjectId, ref: 'Category' },
  name: String
});

mongoose.model('Activity', ActivitySchema);

module.exports = mongoose.model('Activity');

