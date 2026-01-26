import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;

public class HealthServer {
    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        server.createContext("/health", exchange -> {
            String response = """
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Cloud Infra Automation - Health Check</title>
                    <style>
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            margin: 0;
                            padding: 0;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            min-height: 100vh;
                        }
                        .container {
                            background: white;
                            border-radius: 15px;
                            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                            padding: 40px;
                            max-width: 600px;
                            text-align: center;
                        }
                        h1 {
                            color: #667eea;
                            margin: 0 0 10px 0;
                            font-size: 2.5em;
                        }
                        .status {
                            background: #4CAF50;
                            color: white;
                            padding: 10px 20px;
                            border-radius: 5px;
                            display: inline-block;
                            margin: 20px 0;
                            font-weight: bold;
                        }
                        .skills {
                            display: grid;
                            grid-template-columns: repeat(2, 1fr);
                            gap: 15px;
                            margin: 30px 0;
                        }
                        .skill-badge {
                            padding: 15px;
                            border-radius: 10px;
                            color: white;
                            font-weight: bold;
                            font-size: 1.1em;
                        }
                        .azure { background: linear-gradient(135deg, #0078d4, #00a4ef); }
                        .terraform { background: linear-gradient(135deg, #623ce4, #7c3aed); }
                        .docker { background: linear-gradient(135deg, #2496ed, #1d63ed); }
                        .java { background: linear-gradient(135deg, #f89820, #ec7e1f); }
                        .port-info {
                            color: #666;
                            margin-top: 30px;
                            font-size: 0.95em;
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <h1>Cloud Infra Automation</h1>
                        <div class="status"> Server is Running</div>
                        
                        <h2 style="color: #764ba2; margin-top: 30px;">Technical Skills</h2>
                        <div class="skills">
                            <div class="skill-badge azure">Azure</div>
                            <div class="skill-badge terraform">Terraform</div>
                            <div class="skill-badge docker">Docker</div>
                            <div class="skill-badge java">Java</div>
                        </div>
                        
                        <div class="port-info">
                            <p> Port: 8080</p>
                            <p> Health Check: Active and Operational</p>
                        </div>
                    </div>
                </body>
                </html>
                """;

               exchange.getResponseHeaders().set("Content-Type", "text/html; charset=UTF-8");
            exchange.sendResponseHeaders(200, response.getBytes().length);
            exchange.getResponseBody().write(response.getBytes());
            exchange.close();
        });
        server.start();
        System.out.println("Server running on port 8080");
    }
}