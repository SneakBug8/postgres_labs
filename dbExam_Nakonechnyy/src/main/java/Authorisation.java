import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.IOException;
import java.sql.*;

public class Authorisation  extends JFrame {
    public boolean isUnique(){
        System.out.println(loginField.getText());
        String queryUnique = "SELECT * FROM Polzovatel WHERE login='"+
                loginField.getText() + "';";
        Connection connectionPupil = Database.loginConnection();
        if (connectionPupil != null && Validator(loginField)) {
            try {
                Statement statement = connectionPupil.createStatement();
                ResultSet resultSet = statement.executeQuery(queryUnique);
                if (!resultSet.next()) {
                    return true;
                } else {


                    if (!labelExist){
                        AuthorisationPanel.add(errorLable);
                        errorLable.setBounds(screenSize.width/2-465,30,500,30);
                        errorLable.setForeground(new Color(0xD50038));
                        labelExist = true;
                    }
                }
            } catch (SQLException s) {
            }
            labelExist=false;
        }
        return false;
    }

    public static class MyLayout implements LayoutManager{
        public static int widthElement = 400;
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        @Override
        public void addLayoutComponent(String name, Component comp) {}
        @Override
        public void removeLayoutComponent(Component comp) {}
        @Override
        public Dimension preferredLayoutSize(Container parent) {return null;}
        @Override
        public Dimension minimumLayoutSize(Container parent) {return null;}
        @Override
        public void layoutContainer(Container parent) {
            int margin = screenSize.height/15;
            for (int i=0; i<parent.getComponentCount(); i++){
                Component component = parent.getComponent(i);
                component.setBounds(parent.getSize().width/2-widthElement/2,margin, widthElement,40);
                margin+=screenSize.height/20;
            }

        }
    }

    public boolean Validator(JTextField field){
        String regexLogin = "(([a-zA-Z])+([a-zA-Z]+|[0-9]*)+)";
        String regexName = "(([А-Я][а-я]{1,30})+){3}";
        String regexPassword = "";
        switch (field.getText()){
            case "Login":
                return false;
            case "Password":
                return false;
            case "Surname name last name":
                return false;

        }
        switch (field.getName()){
            case "loginField":
                boolean result = field.getText().matches(regexLogin);
                if (!result) JOptionPane.showMessageDialog(AuthorisationPanel,
                        "Логин должен начинаться с буквы и содержать только латинские буквы и цифры ");
                return result;
            case "nameField":
                boolean result4 = field.getText().matches(regexName);
                if (!result4) JOptionPane.showMessageDialog(AuthorisationPanel,
                        "ФИО должно быть вида 'Фамилия Имя Отчество'");
                return result4;

        }
        return true;
    }

    public Authorisation() {
        this.add(AuthorisationPanel);
        AuthorisationPanel.setLayout(new MyLayout());
        AuthorisationPanel.add(loginField);
        AuthorisationPanel.add(passwordField);
        AuthorisationPanel.add(buttonSend);
        AuthorisationPanel.add(goRegistration);
        AuthorisationPanel.setBackground(new Color(255, 255, 127));
        loginField.setText("Login");
        passwordField.setText("Password");
        nameField.setText("Surname Name Last name");
        nameField.setMargin(new Insets(0, 10, 0, 10));
        loginField.setMargin(new Insets(0, 10, 0, 10));
        passwordField.setMargin(new Insets(0, 10, 0, 10));
        buttonSend.setBackground(new Color( 143, 26, 42));
        buttonSend.setForeground(new Color(0,0,0));
        goRegistration.setBackground(new Color(255, 153, 51));
        goRegistration.setForeground(new Color(0,0,0));
        nextStep.setBackground(new Color(255, 153, 51));
        nextStep.setForeground(new Color(0,0,0));
        this.setVisible(true);
        this.setSize(width,height);
        this.setDefaultCloseOperation(EXIT_ON_CLOSE);
        this.setLocation(screenSize.width/2-this.getSize().width/2,
                screenSize.height/2-this.getSize().height/2);
        this.setTitle("Konditerskiye Izdeliya");

        loginField.setName("loginField");
        passwordField.setName("passwordField");

        nameField.setName("nameField");
        buttonSend.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (buttonSend.getText().equals("Login") ){
                    Connection connectionPupil = Database.loginConnection();
                    String sql =
                            "";

                    if (connectionPupil != null && Validator(loginField)) {
                        try {
                            System.out.println(sql);
                            Statement statement = connectionPupil.createStatement();
                            ResultSet resultSet = statement.executeQuery(sql);
                            String hex = (String.valueOf(passwordField.getPassword()));
                            if (resultSet.next() && hex.contentEquals(resultSet.getString("password"))){
                            }
                        } catch (SQLException s) {
                            System.out.println(s);
                        }
                    }

                }
            }
        });
        nextStep.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String login = loginField.getText();
                String fio = nameField.getText();
                String hex = (String.valueOf(passwordField.getPassword()));
                if (Validator(loginField) && Validator(passwordField)&& isUnique()){

                    Connection connectionPupil = Database.loginConnection();
                    AuthorisationPanel.remove(errorLable);
                    AuthorisationPanel.remove(loginField);
                    AuthorisationPanel.remove(passwordField);
                    AuthorisationPanel.remove(buttonSend);
                    AuthorisationPanel.remove(goRegistration);
                    AuthorisationPanel.remove(nextStep);
                    AuthorisationPanel.add(nameField);

                    setPlaceholderTextField(nameField,"Surname name last name");
                    nameField.setMargin(new Insets(0, 10, 0, 10));
                    AuthorisationPanel.updateUI();
                    if(Validator(nameField) && isUnique()) {
                        if (connectionPupil != null) {
                            try {
                                Statement statement = connectionPupil.createStatement();

                            } catch (SQLException se) {

                            }
                        }
                        else {

                        }
                    }
                }
            }
        });
        goRegistration.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (goRegistration.getText().equals("I don't have an account") ){
                    AuthorisationPanel.add(nameField);

                    AuthorisationPanel.remove(buttonSend);
                    AuthorisationPanel.remove(goRegistration);
                    AuthorisationPanel.add(nextStep);
                    AuthorisationPanel.add(goRegistration);

                    goRegistration.setText("I already have an account");
                    //Добавляем плейсхолдеры
                    AuthorisationPanel.updateUI();
                }
                else{
                    AuthorisationPanel.remove(nameField);
                    AuthorisationPanel.remove(nextStep);
                    AuthorisationPanel.remove(goRegistration);
                    AuthorisationPanel.add(buttonSend);
                    AuthorisationPanel.add(goRegistration);
                    goRegistration.setText("I don't have an account");
                    AuthorisationPanel.updateUI();
                }
                AuthorisationPanel.updateUI();
            }
        });
        //Добавляем плейсхолдеры
        setPlaceholderTextField(loginField, "Логин");
        setPlaceholderTextField(passwordField,"Пароль");
    }


    private static int width=1300, height=800;
    private JButton buttonSend = new JButton("Login");
    private JPanel AuthorisationPanel = new JPanel();
    private JButton goRegistration = new JButton("I don't have an account");
    private  JButton nextStep = new JButton("Next");
    private JTextField loginField = new JTextField();
    private JPasswordField passwordField = new JPasswordField();
    private JTextField nameField = new JTextField();

    JLabel errorLable = new JLabel("There is user with same username");
    boolean labelExist = false;
    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();


    public void setPlaceholderTextField(JTextField field, String placeholder){
        field.addFocusListener(new FocusListener() {
            @Override
            public void focusGained(FocusEvent e) {
                if (field.getText().equals(placeholder)) {
                    field.setText("");
                    field.setForeground(Color.BLACK);
                }
            }
            @Override
            public void focusLost(FocusEvent e) {
                if (field.getText().isEmpty()) {
                    field.setForeground(Color.GRAY);
                    field.setText(placeholder);
                }
            }
        });
    }

}
