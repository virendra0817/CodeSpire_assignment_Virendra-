trigger OrderItemTrigger on OrderItem__c (after insert, after update) {
    OrderItemHandler.handleAfterInsertUpdate(Trigger.new);
}