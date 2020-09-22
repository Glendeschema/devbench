using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;


namespace studentportalinC
{
    class Program
    {
        static void Main()
        {

            //Connection string to SQLDB1

            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();

            builder.UserID = "Glen";
            builder.Password = "P@ssw0rd";
            builder.DataSource = "glendb.database.windows.net";
            builder.InitialCatalog = "PoolDB";



            using (SqlConnection conn = new SqlConnection(builder.ConnectionString))
            {

                conn.Open();

                Console.WriteLine("Welcome to Pool Champs APP");
                Console.WriteLine("");
                Console.WriteLine("Please make a Selection");

                Console.WriteLine("1-Register new Player 2-Remove Existing player 3-Exit");

                char response = Console.ReadKey().KeyChar;


                switch (response)
                {
                    case '1':
                        Console.WriteLine("welcome to pool champs please fill in the following info");
                        Console.WriteLine("Enter Player Name");
                        string PlayerName = Console.ReadLine();

                        try
                        {

                            var query = "INSERT INTO Players (PlayerName) VALUES (@playername)";

                            using (SqlCommand command = new SqlCommand(query, conn))
                            {
                                command.Parameters.Add(new SqlParameter("playername", PlayerName));
                                // 2. define parameters used in command object


                                command.ExecuteReader();

                                Console.WriteLine("The playerName {0} has been registered", PlayerName);
                            }
                        }
                        catch (Exception ex)
                        {

                            Console.WriteLine(ex);
                        }


                        break;


                    case '2':

                        Console.WriteLine("Are  you sure want to remove(type YES or NO");

                        var playerName = Console.ReadLine();

                        if (playerName != "NO")
                        {
                            Console.WriteLine("Enter player you wish to remove");
                            var pName = Console.ReadLine();
                            var dQuery = "DELETE FROM Players WHERE PlayerName = @pName ";

                            using (SqlCommand dcommand = new SqlCommand(dQuery, conn))
                            {


                                try
                                {


                                    dcommand.Parameters.Add(new SqlParameter("pName", pName));

                                    var fetchResultsquery = " Select PlayerName FROM Players WHERE PlayerName = @pName";

                                    using (var fetchCommand = new SqlCommand(fetchResultsquery, conn))
                                    {


                                        fetchCommand.Parameters.Add(new SqlParameter("pName", pName));



                                        using (SqlDataReader fetchResults = fetchCommand.ExecuteReader())
                                        {


                                            if (fetchResults.Read())
                                            {
                                                fetchResults.Close();
                                                dcommand.ExecuteReader();

                                                Console.WriteLine(" The Player {0} has been successfully deleted", pName);


                                            }



                                            else
                                            {

                                                Console.WriteLine("Player Doesnt Exist");

                                            }


                                        }

                                    }


                                }
                                catch (Exception ex)
                                {
                                    Console.WriteLine(ex);
                                }


                            }

                        }
                        break;
                }


            }

          

        }
    }
}








            
                

        


    





