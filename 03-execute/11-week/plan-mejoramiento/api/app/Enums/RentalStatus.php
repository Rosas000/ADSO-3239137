<?php

namespace App\Enums;

enum RentalStatus: string
{
    case Active = 'active';
    case Returned = 'returned';
    case Overdue = 'overdue';
}
