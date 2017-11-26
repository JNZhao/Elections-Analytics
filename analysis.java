import java.sql.*;
import java.util.List;
import java.util.Iterator;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
import java.util.ArrayList;

public class Assignment2 extends JDBCSubmission {
    
    public Assignment2() throws ClassNotFoundException {
        
        Class.forName("org.postgresql.Driver");
    }
    
    @Override
    public boolean connectDB(String url, String username, String password) {
        // Implement this method!
        try{
            //Establish connection to the database
            //url,username,password are passed from the outside
            connection=DriverManager.getConnection(url,username,password);
            
            return true;
        }
        catch (SQLException se)
        {
            //fail to connect to the database
            System.err.println("SQL Exception."+
                               "<Message>: " + se.getMessage());
            return false;
        }
        
    }
    
    @Override
    public boolean disconnectDB() {
        // Implement this method!
        try{
            //disconect from the database
            connection.close();
            return true;
        }
        catch (SQLException se)
        {
            //fail to disconnect to the database
            System.err.println("SQL Exception."+
                               "<Message>: " + se.getMessage());
            return false;
        }
    }
    
    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
        // Implement this method!
        try{
            String queryString;
            ResultSet rs;
            PreparedStatement ps;
            
            //the actual query
            queryString = " select e.id AS election_id, cb.id AS cabinet_id "+
            "from parlgov.election e, parlgov.cabinet cb, parlgov.country c "+
            "where e.id = cb.election_id and e.country_id =c.id and c.name ='"+countryName+"' "+
            "order by e.e_date DESC, cb.start_date ASC";
            
            ps = connection.prepareStatement(queryString); //prepare the query
            rs = ps.executeQuery();  //execute the query
            
            //declare two lists for storing the ids of the selected elections and cabinets
            List<Integer> elections = new ArrayList<Integer>();
            List<Integer> cabinets = new ArrayList<Integer>();
            
            //iterate throught the result and add them into the two lists
            while (rs.next()){
                elections.add(rs.getInt("election_id"));
                cabinets.add(rs.getInt("cabinet_id"));
            }
            
            //declare and construct the result as the required class
            ElectionCabinetResult test = new ElectionCabinetResult(elections,cabinets);
            return test;
        }
        catch (SQLException se)
        {
            System.err.println("SQL Exception."+
                               "<Message>: " + se.getMessage());
            return null;
        }
    }
    
    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
        // Implement this method!
        try{
            
            String queryString;
            ResultSet rs;
            PreparedStatement ps;
            
            //the actual query
            queryString = "select p2.id, p1.description||' '||p1.comment AS p1_info, p2.description||' '||p2.comment AS p2_info "+
                "from parlgov.politician_president p1, parlgov.politician_president p2 "+
               "where p1.id = "+politicianName+" and p1.id != p2.id";
            
            //execute the query
            ps = connection.prepareStatement(queryString);
            rs = ps.executeQuery();
            
            //declare the variable to be returned
            List<Integer> similar_politicians= new ArrayList<Integer>();
            
            //iterate through the result from the query
            while (rs.next()){
                //if the two politicians satisfy the similarity threshold
                if(similarity(rs.getString("p1_info"),rs.getString("p2_info")) >= (double)threshold){
                    
                    //add the similar politician to the final result
                    similar_politicians.add(rs.getInt("id"));
                }
            }
            return similar_politicians;
        }
        catch (SQLException se)
        {
            System.err.println("SQL Exception."+
                               "<Message>: " + se.getMessage());
            return null;
        }
    }
    
    public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
        try{
            JDBCSubmission a1 = new Assignment2();
            
            String url;
            String username;
            String password;
            url = "jdbc:postgresql://localhost/csc343h-tianti10";
            username = "tianti10";
            password = "";
            a1.connectDB(url,username,password);
            ElectionCabinetResult test = a1.electionSequence("France");
            System.out.println(test.toString());
            List<Integer> pp = a1.findSimilarPoliticians((int)329,(float)0.1);
            
            
            a1.disconnectDB();
        }
        catch (ClassNotFoundException e){
            System.err.println(e.getMessage());
        }
    }
    
}
