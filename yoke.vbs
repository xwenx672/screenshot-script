update
function update()
updateans = msgbox ("Update?", vbyesno + vbinformation, "Update screenshotscript?")
select case updateans
case vbyes
	wscript.echo "yes"
case vbno
	wscript.echo "no"
end select

end function