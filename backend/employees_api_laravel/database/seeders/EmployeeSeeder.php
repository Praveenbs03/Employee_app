<?php

namespace Database\Seeders;

use App\Models\Employee;
use Illuminate\Database\Seeder;

class EmployeeSeeder extends Seeder
{
    public function run(): void
    {
        Employee::query()->delete();

        Employee::query()->create([
            'name' => 'Alice Johnson',
            'join_date' => '2018-01-15',
            'is_active' => true,
        ]);
        Employee::query()->create([
            'name' => 'Mark Adams',
            'join_date' => '2022-06-01',
            'is_active' => true,
        ]);
        Employee::query()->create([
            'name' => 'Sophia Lee',
            'join_date' => '2016-09-01',
            'is_active' => false,
        ]);
        Employee::query()->create([
            'name' => 'David Kim',
            'join_date' => '2020-03-10',
            'is_active' => true,
        ]);
    }
}

