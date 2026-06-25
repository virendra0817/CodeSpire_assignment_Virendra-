import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchAccounts from '@salesforce/apex/AccountSearchController.searchAccounts';

export default class AccountSearch extends NavigationMixin(LightningElement) {
    @track accounts = [];
    @track isLoading = false;
    searchTerm = '';
    debounceTimer;

    handleSearchChange(event) {
        const value = event.target.value;
        this.searchTerm = value;
        clearTimeout(this.debounceTimer);
        this.debounceTimer = setTimeout(() => {
            this.fetchAccounts();
        }, 300);
    }

    fetchAccounts() {
        if (!this.searchTerm || this.searchTerm.trim() === '') {
            this.accounts = [];
            return;
        }
        this.isLoading = true;
        searchAccounts({ searchTerm: this.searchTerm })
            .then(result => {
                this.accounts = result;
                this.isLoading = false;
            })
            .catch(error => {
                console.error('Error fetching accounts:', error);
                this.accounts = [];
                this.isLoading = false;
            });
    }

    handleRowClick(event) {
        const accountId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    get hasResults() {
        return this.accounts.length > 0 && !this.isLoading;
    }

    get showNoResults() {
        return this.accounts.length === 0 && 
               !this.isLoading && 
               this.searchTerm.trim() !== '';
    }
}