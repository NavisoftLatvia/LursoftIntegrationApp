tableextension 25028828 "Lursoft Vendor Adds" extends Vendor
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