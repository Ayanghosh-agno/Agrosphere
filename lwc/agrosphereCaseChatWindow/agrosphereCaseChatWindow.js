import { LightningElement, track, api, wire } from 'lwc';
import getCaseMessage from '@salesforce/apex/AgrosphereController.getCaseMessage'
import insertCaseMessage from '@salesforce/apex/AgrosphereController.insertCaseMessage'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AgrosphereCaseChatWindow extends LightningElement {
    @api agentType = false;
    @api recordId;
    caseId;
    newMessage = '';
    userType;
    userName;
    @track messages = []
    @track wiredRecords = [];
    @wire(getCaseMessage, { caseId: '$recordId' }) recList(result) {
        this.wiredRecords = result;
        if (result.data) {
            console.log(result.data)
            let userName = result.data.UserName
            this.userName = userName;
            let messagedata = result.data.MessageInfo
            this.messages = messagedata.map((item) => ({
                'Id': item.Id,
                'createdDate': new Date(item.CreatedDate).toLocaleString(),
                'className': item.Sent_by__c == 'Agent' ? 'slds-box agent-message' : 'slds-box user-message',
                'displayName': item.Sent_by__c == 'Agent' ? 'Agrosphere Agent' : userName,
                'message': item.Chat_message__c
            }))
        } else if (result.error) {
            console.error(error);
        }
    }
    connectedCallback() {
        this.agentType ? this.userType = 'Agent' : this.userType = 'User'
    }
    handleMessageChange(event) {
        this.newMessage = event.target.value;
    }
    sendMessage() {
        if (this.newMessage.trim() === '') {
            alert('Please enter a message');
            return;
        }
        const newMessage = {
            'Id': `${this.messages.length + 1}`,
            'createdDate': new Date().toLocaleString(),
            'className': this.userType == 'Agent' ? 'slds-box agent-message' : 'slds-box user-message',
            'displayName': this.userType == 'Agent' ? 'Agrosphere agent' : this.userName,
            'message': this.newMessage,
        };
        insertCaseMessage({ isAgent: this.agentType, caseMessage: this.newMessage, caseId: this.recordId }).then(res => {
            const event = new ShowToastEvent({
                title: 'Message Sent !',
                message: 'Message has been sent',
                variant: 'success',
                mode: 'dismissable'
            });
            this.template.querySelector(".message-box").value = "";
            this.messages = [...this.messages, newMessage];
            this.newMessage = '';
        }).catch(err => {
            console.log(err)
        })
    }
}