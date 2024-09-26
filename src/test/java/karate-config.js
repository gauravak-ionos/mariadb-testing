function fn() {
    var env = karate.env;
    karate.log('karate.env system property was:', env);
    karate.configure('connectTimeout', 9000);
    karate.configure('readTimeout', 9000);
    karate.configure('logPrettyResponse', true);
    karate.configure('ssl', true);

    // This shellEnv is used to get the environment variables from the shell script file
    var shellEnv= java.lang.System.getenv();

    var config = {
        //token to be passed in the header
        authToken: shellEnv.tokenID,
        expiredToken: shellEnv.expiredTokenID,
    }
    if (!env || env == 'local'){
        config.baseUrl = 'http://localhost:8080';
    } else if (env == 'dev') {
        config.baseUrl ='https://dev.paas-service.ionos.com';
    } else if (env == 'qa') {
        config.baseUrl ='https://qa.paas-service.ionos.com';
    } else if (env == 'prod') {
        config.baseUrl ='https://paas-service.ionos.com';
    }

    return config;
}