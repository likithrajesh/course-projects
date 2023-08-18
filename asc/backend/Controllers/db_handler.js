var {Client} = require('pg');

async function fetchquery(qstrng){
    client_options = {
        host: process.env.PG_HOST,
        user: process.env.PG_USER,
        password: process.env.PG_PASSWORD,
        port: process.env.PG_PORT,
        database: process.env.PG_DB_NAME
    };
    const client = new Client(client_options);
    await client.connect();
    
    const results = await client.query(qstrng);
    client.end();
    return results;
}

module.exports = {fetchquery}
