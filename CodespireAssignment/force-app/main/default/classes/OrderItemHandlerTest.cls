@isTest
public class OrderItemHandlerTest {

    static Order__c createOrder() {
        Order__c o = new Order__c(Status__c = 'Pending');
        insert o;
        return o;
    }

    @isTest
    static void testAllDelivered_OrderFulfilled() {
        Order__c order = createOrder();
        List<OrderItem__c> items = new List<OrderItem__c>{
            new OrderItem__c(Order__c = order.Id, Status__c = 'Pending'),
            new OrderItem__c(Order__c = order.Id, Status__c = 'Pending')
        };
        insert items;

        for (OrderItem__c item : items) { item.Status__c = 'Delivered'; }

        Test.startTest();
        update items;
        Test.stopTest();

        Order__c result = [SELECT Status__c FROM Order__c WHERE Id = :order.Id];
        System.assertEquals('Fulfilled', result.Status__c, 'Order should be Fulfilled');
    }

    @isTest
    static void testOneCancelled_OrderPartiallyCancelled() {
        Order__c order = createOrder();
        List<OrderItem__c> items = new List<OrderItem__c>{
            new OrderItem__c(Order__c = order.Id, Status__c = 'Delivered'),
            new OrderItem__c(Order__c = order.Id, Status__c = 'Cancelled')
        };
        insert items;

        Test.startTest();
        items[0].Status__c = 'Delivered';
        update items;
        Test.stopTest();

        Order__c result = [SELECT Status__c FROM Order__c WHERE Id = :order.Id];
        System.assertEquals('Partially Cancelled', result.Status__c,
            'Order should be Partially Cancelled');
    }

    @isTest
    static void testBulk_200Records() {
        Order__c order = createOrder();
        List<OrderItem__c> items = new List<OrderItem__c>();
        for (Integer i = 0; i < 200; i++) {
            items.add(new OrderItem__c(Order__c = order.Id, Status__c = 'Pending'));
        }
        insert items;

        for (OrderItem__c item : items) { item.Status__c = 'Delivered'; }

        Test.startTest();
        update items;
        Test.stopTest();

        Order__c result = [SELECT Status__c FROM Order__c WHERE Id = :order.Id];
        System.assertEquals('Fulfilled', result.Status__c,
            'Order should be Fulfilled after bulk update');
    }
}