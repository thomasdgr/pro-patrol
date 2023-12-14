# Pro patrol


## Implementation to do:

### Orchestrator
This class is the "main" script of the game.

It is responsible for reading and parsing the scenarios files (XML). It initializes the different states of other components as well.
It then "executes" the different steps.


### Coordinator
Bridge to make certain functionalities global
- Create QTEs
- Request Dialogs
- Count points

### Dialog
Public methods:
`RequestDialog(DialogInstance)`
	This displays the dialog as well as the responses and the timer. The timer starts when the dialog is displayed. The dialog triggers the next one when it is over
`ClearDialog()`

### DialogInstance
Fields:
- Text : string
- Response: List/Array(Response or Tuple of (Text,Points))
- Next: Optional/nullable of DialogInstance (not sure if its possible)
- Time: int 
