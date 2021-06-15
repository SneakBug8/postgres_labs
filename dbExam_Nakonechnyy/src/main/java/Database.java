import java.io.IOException;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Database {



    private static Connection createNewConnection(){
        String login = new String("postgres");
        String password = new String("1122");
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Ой! Это же ошибка "+e);
        }
        connection = null;
        try {
            connection = DriverManager.getConnection(DB_URL, login, password);
        } catch (SQLException e) {
            System.out.println("Ой! Это же ошибка "+e  );
        }
        isCreated = true;
        return connection;
    }

    private static String DB_URL =
            "jdbc:postgresql://127.0.0.1:5432/" +
                    "database_exam?useUnicode=true&serverTimezone=Europe/Moscow";
    private static boolean isCreated = false;
    private static Connection connection;

    public static Connection loginConnection() {
        if(isCreated == true) {
            return connection;
        }
        else {
            return createNewConnection();
        }
    }

}
