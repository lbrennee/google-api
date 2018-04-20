$APIKey = 'YourAPIKey'
$InputCSV = '/PathtoInput.csv'
$OutputCSV = '/PathtoOutput.csv'
$Trips = Import-Csv -Path $InputCSV
$Modes = 'driving','transit','bicycling','walking'
$ArrivalTime = '1500009294' #https://www.unixtimestamp.com
$Results = @()

foreach ($Trip in $Trips)
{
   foreach ($Mode in $Modes)
   {
       $Origin = $Trip.Origin
       $Destination = $Trip.Destination
       $DistanceProperty = "{0}Distance" -f $Mode
       $DurationProperty = "{0}Duration" -f $Mode
       $URL = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&mode=$Mode&arrival_time=$ArrivalTime&key=$APIKey"
       $APIResults = Invoke-RestMethod -Uri $URL
       $Trip | Add-Member -NotePropertyName $DistanceProperty -NotePropertyValue $APIResults.rows.elements.distance.value
       $Trip | Add-Member -NotePropertyName $DurationProperty -NotePropertyValue $APIResults.rows.elements.duration.value
   }
   $Results += $Trip
}
$Results | Export-Csv -Path $OutputCSV -NoTypeInformation