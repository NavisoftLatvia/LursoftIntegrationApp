tableextension 25028827 "Lursoft Customer Adds" extends Customer
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