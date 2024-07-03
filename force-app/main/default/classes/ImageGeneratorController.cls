public with sharing class ImageGeneratorController {

    @AuraEnabled(cacheable=true)
    public static String getApiKeyByName(String name){
        OpenAI__mdt ai = OpenAI__mdt.getInstance(name);
        return ai?.API_Key__c;
    }


    @AuraEnabled
    public static String generateImage(String prompt){
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:OpenAI_API' + '/v1/images/generations');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + getApiKeyByName('Default'));
            req.setBody(JSON.serialize(
                new Map<String, Object>{
                    'model' => 'dall-e-3',
                    'prompt' => prompt,
                    'n' => 1,
                    'size' => '1024x1024'
                }
            ));
            req.setTimeout(120000);
            Http http = new Http();
            HttpResponse response = http.send(req);
            return response.getBody();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}