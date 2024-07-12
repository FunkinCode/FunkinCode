const {Objects, States, FamilyMemberType} = require("RealLife")	
global.people.me.family.forEach(familyMember=>{
	if (typeof familyMember === FamilyMemberType.Father) {
		if (familyMember.state === States.Missing)
			familyMember.state = States.Appeared;


		familyMember.inventory.push(
		{
			...Objects.milk_base,
			quantity: 4 * 1000 // en mini litros
		}
			)
		familyMember.inventory.push({
			...Objects.tortillas,
			quantity: 500 // 1/2 de tortillas
		})

	}
})