$http = [System.Net.HttpListener]::new() 

$http.Prefixes.Add("http://localhost:3000/")

$http.Start()

if ($http.IsListening) {
    write-host " Server Start on $($http.Prefixes) " -f 'gre'
}

 while ($http.IsListening) { 

    $context = $http.GetContext()

    if ($context.Request.HttpMethod -eq 'GET') {

        $now = Get-Date

        $path = $context.Request.Url.AbsolutePath
        if ($path -eq "/") {
            $path = "/index.html"
        }
        
        try {
            if (Test-Path -Path "./$($path)") {
                [string]$html = Get-Content "./$($path)" -Raw
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
                $context.Response.ContentLength64 = $buffer.Length
                $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
                write-host "[$($now)]: $($context.Request.UserHostAddress)  ->  $($context.Request.Url.AbsolutePath)" -f 'cyan'
            }
            else {
                $context.Response.StatusCode = 404
                write-host "[$($now)]<404>: $($context.Request.UserHostAddress)  ->  $($context.Request.Url.AbsolutePath)" -f 'red'
            }
        }
        catch {
            write-host "[$($now)]<Error>: $($Error)" -f 'red'
            $context.Response.StatusCode = 404
            write-host "[$($now)]<404>: $($context.Request.UserHostAddress)  ->  $($context.Request.Url.AbsolutePath)" -f 'red'
        }
        finally {
            $context.Response.OutputStream.Close()
        }
    
    }
}