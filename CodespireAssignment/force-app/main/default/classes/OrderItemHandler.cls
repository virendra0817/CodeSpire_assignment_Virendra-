public class OrderItemHandler {

    public static void handleAfterInsertUpdate(List<OrderItem__c> newItems) {
        
        Set<Id> orderIds = new Set<Id>();
        for (OrderItem__c item : newItems) {
            orderIds.add(item.Order__c);
        }

        Map<Id, List<OrderItem__c>> orderToItemsMap = new Map<Id, List<OrderItem__c>>();
        for (OrderItem__c item : [
            SELECT Id, Status__c, Order__c
            FROM OrderItem__c
            WHERE Order__c IN :orderIds
        ]) {
            if (!orderToItemsMap.containsKey(item.Order__c)) {
                orderToItemsMap.put(item.Order__c, new List<OrderItem__c>());
            }
            orderToItemsMap.get(item.Order__c).add(item);
        }

        List<Order__c> ordersToUpdate = new List<Order__c>();

        for (Id orderId : orderToItemsMap.keySet()) {
            List<OrderItem__c> items = orderToItemsMap.get(orderId);

            Boolean allDelivered = true;
            Boolean anyCancelled = false;

            for (OrderItem__c item : items) {
                if (item.Status__c != 'Delivered') {
                    allDelivered = false;
                }
                if (item.Status__c == 'Cancelled') {
                    anyCancelled = true;
                }
            }

            String newStatus;
            if (allDelivered) {
                newStatus = 'Fulfilled';
            } else if (anyCancelled) {
                newStatus = 'Partially Cancelled';
            } else {
                newStatus = 'Pending';
            }

            ordersToUpdate.add(new Order__c(
                Id = orderId,
                Status__c = newStatus
            ));
        }

        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }
}