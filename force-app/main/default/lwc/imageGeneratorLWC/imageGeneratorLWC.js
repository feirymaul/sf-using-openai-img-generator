import { LightningElement, wire } from 'lwc';
import getApiKeyByName from '@salesforce/apex/ImageGeneratorController.getApiKeyByName';
import generateImage from '@salesforce/apex/ImageGeneratorController.generateImage';

export default class ImageGeneratorLWC extends LightningElement {


    _apiKey;
    _prompt;
    imageUrl;
    revisedPrompt;
    isLoading = true;

    connectedCallback(){
        getApiKeyByName({name: 'Default'})
        .then(result =>{
            this._apiKey = result;
            this.isLoading = false;        
        });
    }

    get apiKey(){
        return this._apiKey;
    }

    handlePromptChange(event){
        this._prompt = event.target.value;
    }

    generateImageHandler(){
        this.isLoading = true;
        generateImage({prompt: this._prompt})
        .then(result =>{
            console.log(result)
            let parsedStr = JSON.parse(result);
            this.revisedPrompt =  parsedStr.data[0].revised_prompt;
            this.imageUrl = parsedStr.data[0].url;
            this.isLoading = false;
        });
    }

}