tableextension 25028829 "Lursoft Contact Adds" extends Contact
{
    fields
    {
       field(25023370; "Has Lursoft warning"; Boolean)
       {
       }
       field(25023371; "Lursoft client URL"; Text[250])
       {
           ExtendedDatatype = URL;
           Editable = false;
       }
    }
}