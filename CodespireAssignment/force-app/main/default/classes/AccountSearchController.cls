public with sharing class AccountSearchController {

    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchTerm) {
        String keyword = '%' + String.escapeSingleQuotes(searchTerm) + '%';
        return [
            SELECT Id, Name, Industry, Phone, AnnualRevenue
            FROM Account
            WHERE Name LIKE :keyword
            WITH SECURITY_ENFORCED
            LIMIT 50
        ];
    }
}