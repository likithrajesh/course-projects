var bcrypt = require('bcrypt');

async function hashit (password,saltRounds){bcrypt
  .genSalt(saltRounds)
  .then(salt => {
    console.log('Salt: ', salt)
    return bcrypt.hash(password, salt)
  })
  .then(hash => {
    console.log('Hash: ', hash)
    return hash
  })
  .catch(err => console.error(err.message))
}

hashit('man@123',10);


