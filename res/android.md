# 打开 platforms/andriod/CordovaLib/src/org/apache/cordova/engine/SystemWebViewClient.java
```
    public void clearAuthenticationTokens() {
        this.authenticationTokens.clear();
    }
    
    private static final String INJECTION_TOKEN = "http://10.242.18.16:9999/static/"; //新增 commit + rootpath

    @Override
    @SuppressWarnings("deprecation")
    public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
        //-----------新增-----------
        if(url != null && url.contains(INJECTION_TOKEN)) {
            String assetPath = url.substring(url.indexOf(INJECTION_TOKEN) + INJECTION_TOKEN.length(), url.length());
            try {
                WebResourceResponse response = new WebResourceResponse(
                        "application/javascript",
                        "UTF8",
                        view.getContext().getAssets().open(assetPath)
                );
                return response;
            } catch (IOException e) {
                e.printStackTrace(); // Failed to load asset file
                return new WebResourceResponse("text/plain", "UTF-8", null);
            }
        }
		//-----------新增-----------
        try {
            // Check the against the whitelist and lock out access to the WebView directory
            // Changing this will cause problems for your application
            if (!parentEngine.pluginManager.shouldAllowRequest(url)) {
                LOG.w(TAG, "URL blocked by whitelist: " + url);
                // Results in a 404.
                return new WebResourceResponse("text/plain", "UTF-8", null);
            }
```

