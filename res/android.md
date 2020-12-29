# 打开 platforms/andriod/CordovaLib/src/org/apache/cordova/engine/SystemWebViewClient.java
```
    public void clearAuthenticationTokens() {
        this.authenticationTokens.clear();
    }
    
    private static final String INJECTION_TOKEN = "http://10.242.18.16:9999/static/c4610f7829701aadb045d450013b84491c30580d/root/code-server/"; //新增 commit + rootpath

    @Override
    @SuppressWarnings("deprecation")
    public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
        //-----------新增-----------
        if(url != null && url.contains(INJECTION_TOKEN) && url.toLowerCase().endsWith(".js")) {
            String assetPath = url.substring(url.indexOf(INJECTION_TOKEN) + INJECTION_TOKEN.length(), url.length());
            try {
                WebResourceResponse response = new WebResourceResponse(
                        "application/javascript",
                        "UTF8",
                        view.getContext().getAssets().open("www/"+assetPath)
                );
                return response;
            } catch (IOException err) {
                err.printStackTrace(); // Failed to load asset file
                try {
                    // Check the against the whitelist and lock out access to the WebView directory
                    // Changing this will cause problems for your application
                    if (!parentEngine.pluginManager.shouldAllowRequest(url)) {
                        LOG.w(TAG, "URL blocked by whitelist: " + url);
                        // Results in a 404.
                        return new WebResourceResponse("text/plain", "UTF-8", null);
                    }

                    CordovaResourceApi resourceApi = parentEngine.resourceApi;
                    Uri origUri = Uri.parse(url);
                    // Allow plugins to intercept WebView requests.
                    Uri remappedUri = resourceApi.remapUri(origUri);

                    if (!origUri.equals(remappedUri) || needsSpecialsInAssetUrlFix(origUri) || needsContentUrlFix(origUri)) {
                        CordovaResourceApi.OpenForReadResult result = resourceApi.openForRead(remappedUri, true);
                        return new WebResourceResponse(result.mimeType, "UTF-8", result.inputStream);
                    }
                    // If we don't need to special-case the request, let the browser load it.
                    return null;
                } catch (IOException e) {
                    if (!(e instanceof FileNotFoundException)) {
                        LOG.e(TAG, "Error occurred while loading a file (returning a 404).", e);
                    }
                    // Results in a 404.
                    return new WebResourceResponse("text/plain", "UTF-8", null);
                }
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

## 修改 plugins/cordova-plugin-whitelist/src/android/WhitelistPlugin.java:
```
    @Override
    public Boolean shouldAllowNavigation(String url) {
        if (allowedNavigations.isUrlWhiteListed(url)) {
            return true;
        }
        return true; // Default policy
    }
```