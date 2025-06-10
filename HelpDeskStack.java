import java.util.Scanner;
import java.util.Stack;

public class HelpDeskStack {
    public static void main(String[] args) {
        Stack<String> helpDesk = new Stack<>();
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("\n1. Raise Support Request");
            System.out.println("2. Solve Next Request");
            System.out.println("3. View Pending Requests");
            System.out.println("4. Exit");
            System.out.print("Enter your choice: ");
            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            switch (choice) {
                case 1:
                    System.out.print("Enter student's support request: ");
                    String request = scanner.nextLine();
                    helpDesk.push(request);
                    System.out.println("Request added to the stack.");
                    break;
                case 2:
                    if (helpDesk.isEmpty()) {
                        System.out.println("No pending requests.");
                    } else {
                        System.out.println("Solving request: " + helpDesk.pop());
                    }
                    break;
                case 3:
                    System.out.println("Pending Requests: " + helpDesk);
                    break;
                case 4:
                    System.out.println("Exiting Help Desk.");
                    return;
                default:
                    System.out.println("Invalid choice. Try again.");
            }
        }
    }
}

