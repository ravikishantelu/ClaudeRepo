/**
 * Batch class to find all open Leads that have been open for more than 60 days
 * and create a follow-up Task assigned to the Lead owner with a 2-day due date.
 * KAN-1
 */
public with sharing class LeadFollowUpBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date cutoffDate = Date.today().addDays(-60);
        return Database.getQueryLocator([
            SELECT Id, OwnerId
            FROM Lead
            WHERE IsConverted = false
            AND IsClosed = false
            AND CreatedDate <= :cutoffDate
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Lead> leads) {
        Date dueDate = Date.today().addDays(2);
        List<Task> tasksToInsert = new List<Task>();

        for (Lead lead : leads) {
            tasksToInsert.add(new Task(
                Subject = 'Close the Lead or mark it Bogus',
                WhoId = lead.Id,
                OwnerId = lead.OwnerId,
                ActivityDate = dueDate,
                Status = 'Not Started',
                Priority = 'Normal'
            ));
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    public void finish(Database.BatchableContext bc) {
    }
}
